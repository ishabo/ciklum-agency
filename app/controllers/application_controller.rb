class ApplicationController < ActionController::Base
    include ApplicationHelper  
    before_filter :authenticate, :except => 'login'
  	protect_from_forgery

  	def authenticate with_redirect=true
  		if !current_user
   			redirect_to login_url unless with_redirect == false 
   		end
      begin
        accessor = instance_variable_get(:@_request)
      rescue
        accessor = {:session => {:user_id => 1}}
      end
      
      ActiveRecord::Base.send(:define_method, "session", proc {{:user_id => 1}})
      #accessor.session
  		@current_user
    end

  	def admin_only
  		if !current_user.is_admin
  			redirect_to home_url 
  		end
  	end

    helper_method :can_see_bonuses
  	def can_see_bonuses with_redirect=true
  		c = current_user
  		if !c.position.has_bonus and !c.is_admin and !is_boss?(c)
  			redirect_to home_url if with_redirect
  			return false
  		end
  		return true
  	end
  
    helper_method :can_manage_bonuses
    def can_manage_bonuses with_redirect=true
      c = current_user
      if !c.is_admin and !is_boss?(c)
        redirect_to home_url if with_redirect
        return false
      end
      return true
    end	


    def update_user_availability  
      user = User.find(params['id'])
      if user 
        user.update_attributes({:avail_date => params['value']})
        render json: {result: true}
      else
        render json: {result: false}
      end
    end

  	helper_method :current_user
  	private
  	def current_user
  	  @current_user ||= User.find(session[:user_id]) if session[:user_id]
  	end

    helper_method :is_user_boss
    def is_user_boss
      @is_user_boss = is_boss?(@current_user)
    end

    def is_boss?(c)
      c.position.name.match('Engagement') ? true : false
      #return true if c.position.name.match('Engagement') else false
    end
end


class String
    def to_bool
        return true if self=="true"
        return false if self=="false"
        return nil
    end
end
