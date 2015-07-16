class BonusesController < ApplicationController
  
  before_filter :can_see_bonuses
  
  def index
    @user_id = params[:id] ? params[:id] : @current_user.id
    @is_boss = is_boss?(@current_user)
    if @is_boss and !params[:id] 
      @user_id = 1
    end
    @bonus_user = User.find(@user_id)
    name_split = @bonus_user.name.split(' ')
    @bonus_owner = params[:id] ? "#{name_split[0]}'s bonuses" : "Bonuses"
    if request.xhr?
      if !@bonus_user.has_bonus
        render :text => "invalid"
      else
        @bonuses = Bonus.where('user_id' => @user_id).order('payment_date DESC, CONCAT(due_month, YEAR(created_at)) ASC' )
        render :template => 'bonuses/bonus_tabs.html.haml', :layout => false
      end
    end
  end

  def claim
  	bonus = Bonus.find(params[:id])
    claimed = params[:claimed] == 'true' ? 1 : 0
  	bonus.update_attributes({:claimed => claimed})
  	respond_to do |format|
      format.html # show.html.erb
      format.json { render json: params[:claimed] }
    end
  end

  def prep_payments
      @bonus_ids = params[:bonuses]
      bonus_ids = @bonus_ids.split(",")
      @bonuses = Bonus.where('id IN (?)', bonus_ids)
      @bonuses.where('paid = ?', false)
      @bonuses.group('user_id')
      render :template => 'bonuses/bonuses_email.html.haml', :layout => false
  end

  def pay
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: do_pay(params[:id], params[:paid]) }
    end
  end

  def do_pay id, bool
    if bool.respond_to? :to_bool
      bool = bool.to_bool 
    end
    bonus = Bonus.find(id)
    paid = bool == true ? 1 : 0
    date = bool == true ? Date.today : nil
    bonus.update_attributes(
        {:paid => paid, :payment_date => date}
    )
    return paid
  end

  def batch_pay
    params[:server]      ||= 'localhost'
    params[:from]        ||= 'iss@ciklum.com'
    params[:to]          ||= 'iss@ciklum.com'
    params[:from_alias]  ||= 'Ciklum Agency'
    params[:subject]     ||= "You need to see this"
    params[:body]        ||= "Important stuff!"
message = <<MESSAGE_END
From: #{params[:from_alias]} <#{params[:from]}>
To: <#{params[:to]}>
Subject: #{params[:subject]}

#{params[:body].gsub(/\r\n/, '<br />')}.
MESSAGE_END
    Pony.mail(:to => params[:to], 
              :from => params[:from], 
              :subject => params[:subject], 
              :body => params[:body].gsub(/\r\n/, '<br />'),
              :headers => { 'Content-Type' => 'text/html' })

    bonus_ids = params[:bonus_ids].split(",")
    bonus_ids.each do |bonus_id|
      do_pay bonus_id, true
    end
    render json: params
  end

  def claimed
    @bonuses = Bonus.find(:all, :conditions => {'claimed' => true})
  end

  helper_method :classes
  def classes
    @classes = {1 => 'potential_bonus', 2 => 'due_bonus', 3 => 'lost_bonus'}
  end

  def update_value
    bonus = Bonus.find(params['id'])
    if bonus 
      bonus.update_attributes({:value => params['value']})
      render json: {result: true}
    else
      render json: {result: false}
    end
  end
end