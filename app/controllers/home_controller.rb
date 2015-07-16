# Home Controller displays a dashboard of the upcomming services
class HomeController < ApplicationController

  def index
    
    params[:year] = Date.today.year if !params[:year]
    
    json_data = {}

    if is_ajax?
      json_data = get_monthly_services(params)
    else 
      get_dashboard
    end
    json_data[:get_months] = get_months(params[:year])
    render_index(json_data)
  end

  def render_index(json_data)
    if current_user
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: json_data}
      end
    end
  end

  def get_dashboard
      @activities = Service.new.get_users_services
      @upcomming_work = {"Workshops" => Service.where_upcoming_work('ws'), "UX" => Service.where_upcoming_work('ux')}
      @conversion_rate = Project.new.get_projects_conversion_rate    
  end

  def get_monthly_services (filters)
    
    if params[:revenue].to_i == 1
      json_data = Service.new.get_monthly_revenue filters
    else
      @won = Service.new.get_monthly_won_services(filters)
      @lost = Service.new.get_monthly_lost_services(filters)
      @potential = Service.new.get_monthly_potential_services(filters)
      booked = Service.new.get_monthly_booked_services(filters)
      in_progress = Service.new.get_monthly_in_progress_services(filters)
      booked_and_inprogress = get_booked_and_in_progress(booked, in_progress)

      max = [@lost.max, @won.max, booked_and_inprogress.max ,@potential.max].max
      json_data = {:won => @won, :lost => @lost, :potential => @potential,:booked => booked_and_inprogress, :max => max}
    end
  end

  def get_booked_and_in_progress (booked, in_progress)
      booked_and_inprogress = []
      $i = 0
      while $i < booked.length do
        booked_and_inprogress[$i] = booked[$i] + in_progress[$i]
        $i += 1
      end
      booked_and_inprogress
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