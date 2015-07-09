class HomeController < ApplicationController

  def index
    if params[:year] == nil
      params[:year] = Date.today.year
    end
    
    if params[:service] == nil
      params[:service] = 'ws'
    end
    
    json_data = {}

    if request.xhr?
      filters = {}
      filters[:service_type] = params[:service]
      filters[:year] = params[:year]
      if params[:consultant].to_i != 0
        filters[:consultant] = params[:consultant]
      end
      
      if params[:revenue] == '1'
        json_data = Service.new.get_monthly_revenue filters
      else
        @won = Service.new.get_monthly_won_services filters
        @lost = Service.new.get_monthly_lost_services filters
        @potential = Service.new.get_monthly_potential_services filters
        @booked = Service.new.get_monthly_booked_services filters
        @in_progress = Service.new.get_monthly_in_progress_services filters
        booked_and_inprogress = []
        $i = 0

        while $i < @booked.length do
          booked_and_inprogress[$i] = @booked[$i] + @in_progress[$i]
          $i += 1
        end
        max = [@lost.max, @won.max, @booked.max ,@potential.max].max
        json_data = {:won => @won, :lost => @lost, :potential => @potential,:booked => booked_and_inprogress, :max => max}
      end
    else 
      @activities = Service.new.get_users_services
      @upcomming_work = {"Workshops" => Service.where_upcoming_work('ws'), "UX" => Service.where_upcoming_work('ux')}
      @conversion_rate = Project.new.get_projects_conversion_rate
      # @conversion_rate.map do |sym, val|
      #   sym = sym.to_s.gsub!(/_/, ' ').capitalize
      # end
    end

    json_data[:get_months] = get_months(params[:year])
    if current_user
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: json_data}
      end
    end
  end

  def login
    if authenticate(false)
      redirect_to home_url
    end
  	if params[:email]
	    @user = User.authenticate(params[:email], params[:password])
	    if @user
	      session[:user_id] = @user.id
	      redirect_to root_url, :notice => "Logged in!"
	    else
	      flash.now.alert = "Invalid email or password"
	    end
	end
  end

  def logout
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
   end
end