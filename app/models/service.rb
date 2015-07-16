class Service < ActiveRecord::Base
  include ApplicationHelper  

	attr_accessible  :description, :duration, :budget, :project_id, :sold_by, :user_id, :created_by, :proposal_sent, :spec_sent, :start_date, :service_type_id, :success_status, :is_paid, :status_comment
	attr_accessor :skip_grant_bonus_callback

	attr_accessor :total_revenue
	belongs_to :project
	belongs_to :consultant, :class_name => "User", :foreign_key => "user_id"
	belongs_to :service_type
	belongs_to :sales_force, :class_name => "User", :foreign_key => "sold_by"
	belongs_to :creator, :class_name => "User", :foreign_key => "created_by"

	validates_presence_of :project_id
	validates_presence_of :user_id
	validates_presence_of :budget
	validates_presence_of :start_date 
	validates_presence_of :service_type
	validates :status_comment, :presence => true, :if => :is_lost?

	after_create :grant_bonus
	after_update :grant_bonus
	skip_callback :create, :after, :grant_bonus, if: :skip_grant_bonus_callback

	scope :select_sum_or_count, -> (service_type, revenue) { revenue ? Service.get_budget_sum(service_type) : select("count(services.success_status) AS sum_count").first.sum_count } 
	scope :where_service_type, -> (service_type, project_status) { Service.get_by_service_type(service_type, project_status) }
	scope :where_consultant, -> (consultant) { where(:user_id => consultant) if consultant}
	scope :where_success_status, -> (service_type, status) { where('services.success_status' => self.is_conversion?(service_type) ? Service.statuses[:completed] : status)}
	scope :where_upcoming_work, -> (service_type) { where(:service_type_id => ServiceType.find_by_key_name(service_type), :success_status => Service.statuses[:booked]).order("start_date")}


	def self.get_budget_sum(service_type)
		sum(self.is_conversion?(service_type) ? 'projects.budget' : 'services.budget', :group => 'month(services.start_date)')
	end

	def self.get_by_service_type (service_type, project_status)
		where_statement = where('services.service_type_id' => ServiceType.new.get_ids_for_bonus(service_type))
		where_statement.where('projects.converted' => project_status) if self.is_conversion?(service_type)
	end

	def self.statuses
		{ potential: 1, booked: 2, in_progress: 3, completed: 4, lost: 5 }
	end

	def is_potential?
		success_status == Service.statuses[:potential]
	end

	def is_booked?
		success_status == Service.statuses[:potential]
	end

	def is_in_progress?
		success_status == Service.statuses[:in_progress]
	end

	def is_completed?
		success_status == Service.statuses[:completed]
	end

	def is_lost?
		success_status == Service.statuses[:lost]
	end

	def get_workshop_consultant  
		Service.where('project_id = ? and service_type_id = ?', project_id, ServiceType.new.get_id('ws')).first.consultant
	end

	def prep_bonuses_for_service
		bonuses = {}

		bonuses[service_type.key_name] = {
			:bonus_winner => sales_force,
			:has_bonus => sales_force.has_bonus
		} if sales_force

		ws_consultant = get_workshop_consultant()

		# prepare project conversion bonus for the consultant who carried out a workshop for the same project
		bonuses['conversion'] = {
			:bonus_winner => ws_consultant,
			:has_bonus => ws_consultant.has_bonus
		} if ws_consultant
		bonuses
	end

	# grant_bonus runs after create and after update
	def grant_bonus
		who_got_bonus = {}
		prep_bonuses_for_service.each do |reason, info|
			#next if !bonus_scheme # || info['has_bonus'] == false || info['bonus_winner'] == false
			bonus = register_bonus(BonusScheme.where('key_name = ?', reason).first, info[:bonus_winner])
			(who_got_bonus[bonus.user.name] ||= {}).merge!({reason => bonus.value}) if bonus
		end
		who_got_bonus
	end

	def is_consultant_the_bonus_winner?(bonus_winner)
		consultant == bonus_winner
	end

	def is_seller_the_bonus_winner?(bonus_winner)
		(sales_force && sales_force == bonus_winner)
	end

	def is_ancient?
		return (start_date.year <= 2012 && start_date.month < 7)
	end

  def is_bonus_valid?(bonus_scheme, bonus_winner)
    return true unless (!bonus_scheme || (!is_consultant_the_bonus_winner?(bonus_winner) && bonus_scheme.is_conversion?) || (!is_seller_the_bonus_winner?(bonus_winner) && !bonus_scheme.is_conversion?))
  end

	def register_bonus(bonus_scheme, bonus_winner)	
		return false unless is_bonus_valid?(bonus_scheme, bonus_winner)

		bonus = Bonus.find_bonus_for_service(self, bonus_scheme, bonus_winner)

		return bonus.destroy_bonus if is_ancient?
		return false if bonus.paid

		return bonus.update_bonus_eligibility
	end

	def get_projects_count_by_month(filters, month)
		#filters.each { |key, val| instance_variable_set(:"@filters_#{key}", val) }
		hash_to_vars(filters, "filters_")
		Service.joins(:project).where_consultant(@filters_consultant)
						.where_service_type(@filters_service_type, @filters_status)
						.where_success_status(@filters_service_type, @filters_status)
						.where(["month(services.start_date) = ? AND year(services.start_date) = ?", month, @filters_year])
						.select_sum_or_count(@filters_service_type, @filters_revenue)
	end

	# Get monthly projects method is used with different filters by the controller
	# filters is a hash object serving the following params year, service_type, status, revenue = false, consultant = 0
	def aggregate_projects_monthly_count (filters)
		filters[:consultant] = nil if filters[:consultant].to_i == 0
		filters[:service] = 'ws' if !filters[:service]

		list = []
  	1.upto(12) { |month| list << get_projects_count_by_month(filters, month) }
		list
  end


	def get_monthly_won_services (filters) #service_type, year, consultant = 0
		filters[:status] = Service.statuses[:completed]
		aggregate_projects_monthly_count filters #year, service_type, Service.statuses[:completed], false, consultant
	end

	def get_monthly_lost_services (filters) #service_type, year, consultant = 0
		filters[:status] = Service.statuses[:lost]
		aggregate_projects_monthly_count filters #year, service_type, Service.statuses[:lost], false, consultant
	end

	def get_monthly_potential_services (filters) #service_type, year, consultant = 0
		filters[:status] = Service.statuses[:potential]
		aggregate_projects_monthly_count filters # year, service_type, Service.statuses[:potential], false, consultant
	end

	def get_monthly_booked_services (filters) #service_type, year, consultant = 0
		filters[:status] = Service.statuses[:booked]
		aggregate_projects_monthly_count filters # year, service_type, Service.statuses[:booked], false, consultant
	end

	def get_monthly_in_progress_services (filters) #service_type, year, consultant = 0
		filters[:status] = Service.statuses[:in_progress]		
		aggregate_projects_monthly_count filters # year, service_type, Service.statuses[:in_progress], false, consultant
	end

	def aggregate_total_monthly_revenue()
		
		0.upto(11) {|mon| (@total_revenue[:grand_total] ||= 0) << @total_revenue[:completed][mon].to_i+@total_revenue[:lost][mon].to_i }

	end

	def get_monthly_revenue (filters) #service_type, year, consultant = 0

		filters[:revenue] = true
		@total_revenue = {
			completed: aggregate_completed_projects_monthly_count(filters),
			lost: aggregate_lost_projects_monthly_count(filters),
			potential: aggregate_potential_projects_monthly_count(filters)}
		aggregate_total_monthly_revenue()
		@total_revenue
    #{'completed' => completed, 'lost' => lost, 'potential' => potential, 'grand_total' => grand_total}
	end

	def aggregate_completed_projects_monthly_count(filters)
		filters[:status] =  ApplicationHelper.is_conversion?(filters[:service_type]) ? Project.conversion_status[:won] : Service.statuses[:completed]#, :won, :completed
		aggregate_projects_monthly_count filters #year, service_type, won_status, true, consultant
	end

	def aggregate_lost_projects_monthly_count(filters)
		filters[:status] =  ApplicationHelper.is_conversion?(filters[:service_type]) ? Project.conversion_status[:lost] : Service.statuses[:lost]#
		aggregate_projects_monthly_count filters #year, service_type, won_status, true, consultant
	end

	def aggregate_potential_projects_monthly_count(filters)
		filters[:status] =  ApplicationHelper.is_conversion?(filters[:service_type]) ? Project.conversion_status[:pending] : Service.statuses[:potential]#
		aggregate_projects_monthly_count filters #year, service_type, won_status, true, consultant
	end


	def get_users_services
		Service.where('services.success_status IN (?)', Service.statuses.map { |key, val| val if key.in?([:booked, :in_progress, :completed])}.compact) #[completed, in_progress, booked]
				.where("DATE_FORMAT(services.start_date,'%m %Y') IN (?)", [
																ApplicationHelper.last_month("%m %Y"), 
																ApplicationHelper.this_month("%m %Y"),
																ApplicationHelper.next_month("%m %Y"),
																ApplicationHelper.in_x_months(2, "%m %Y"),
																ApplicationHelper.in_x_months(3, "%m %Y"),
																])
				.order('user_id, start_date')
	end


	def self.is_conversion?(service_type)
		 ApplicationHelper.is_conversion?service_type
	end



	def hash_to_vars(hash_object, prefix = "_")
		hash_object.each do |key, val|
    	instance_variable_set(:"@#{prefix}#{key}", val)
    end
	end	

end