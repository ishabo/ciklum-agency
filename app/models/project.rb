# Project Model is a mirror to projects created inside the Ciklum Hub system, with hub_id reference.
# It has a one-to-many relationship to Service Model. Projects are created while creating a service
# if the user finds no record of the project, otherwise an existing project is chosen and service is
# created in reference to it.
class Project < ActiveRecord::Base
	include ApplicationHelper

	attr_accessible :client, :description, :hub_id, :name, :project_manager, :sales_manager, :budget, :converted, :engagement_type, :status_comment, :abc
	has_many :services
	has_many :users, :through => :services
	validates_presence_of :client
	validates_presence_of :name
	validates_presence_of :project_manager	
	validates_presence_of :sales_manager
	validates_presence_of :hub_id
	validates_presence_of :abc
	validates_uniqueness_of :name
	validates :status_comment, :presence => true, :if => :is_lost?

	scope :find_by_service_year, lambda {|year| Project.find_by_year(year) if ApplicationHelper.year_valid?(year)  } #year_valid?(year) 
	scope :find_by_project_status, lambda {|status| where(converted: status) if status} 
	scope :find_by_service_consultant, lambda {|consultant| where('services.user_id' => consultant) if consultant } 

	def self.find_by_year(year)
		if ApplicationHelper.is_mysql?
			where("YEAR(services.start_date) = ?", year)
		else
			where("services.start_date >= ? and services.start_date <= ?", "#{year}-01-01", "#{year}-12-31")
		end
	end

	def self.engagement_types
		{ project_delivery: 1, rate_card: 2, service_only: 3}
	end

	def self.conversion_status 
		{pending: 0, won: 1, lost: 2}
	end

	def self.client_abc
		{0 => 'A', 1 => 'B', 2 => 'B+', 3 => 'C'}
	end

	def is_lost?
		self.converted == Project.conversion_status[:lost]
	end

	# This method calculates the rate of converted projects through the workshop service
	# it finds those marked as Won, Lost and Pending conversion, calculates the rate of those won to the won and lost
	# and returns a hash of all the totals
	def get_projects_conversion_rate year = 0, consultant = 0 
		filters = {}
		filters[:year] = year unless year == 0
		filters[:consultant] = consultant unless consultant == 0 || consultant == 'all'

		Project.hash_conversion_rate({
			all: count_all_projects(filters),
			won: count_won_projects(filters),
			lost: count_lost_projects(filters),
			pending: count_pending_projects(filters)}
		)
	end

	def self.hash_conversion_rate(totals) 
		totals.each do |key,val|
    	instance_variable_set(:"@#{key}", val)
    end

		{
			:total => [:all, @all, 'Total Projects'], 
			:pending => [:pending, @pending, 'Pending Conversion'], 
			:converted => [:won, @won, 'Won :)'], 
			:lost => [:lost, @lost, 'Lost :('], 
			:conversion_rate => [:rate, ApplicationHelper.calc_conversion_date(@won, @lost), 'Conversion Rate']
		}
	end

	def count_all_projects(filters)
		filters[:status] = nil
		count_projects(filters)
	end

	def count_pending_projects(filters)
		filters[:status] = Project.conversion_status[:pending]
		count_projects(filters)
	end

	def count_won_projects(filters)
		filters[:status] = Project.conversion_status[:won]
		count_projects(filters)
	end

	def count_lost_projects(filters)
		filters[:status] = Project.conversion_status[:lost]
		count_projects(filters)
	end

	def count_projects (filters)
			Project.joins(services: :service_type)
												.where('service_types.key_name' => 'ws')
												.where('services.success_status' => Service.statuses.collect{ |key, val| val if [:completed, :completed].include? key }) 
												.find_by_service_year(filters[:year])
												.find_by_project_status(filters[:status])
												.find_by_service_consultant(filters[:consultant]).count

	end

	def is_won?
		converted == Project.conversion_status[:won]
	end

	def is_lost?
		converted == Project.conversion_status[:lost]
	end

end
