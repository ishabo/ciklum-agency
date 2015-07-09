require 'spec_helper'

describe Service do

	before(:all) do
  		@issa_consultant = FactoryGirl.create(:user, :issa)
  		@max_consultant = FactoryGirl.create(:user, :max)
   		@ws_service = FactoryGirl.create :service_type, :ws
   		@ux_service = FactoryGirl.create :service_type, :ux
   		@ttr_service = FactoryGirl.create :service_type, :ttr
	end

	def get_bonus service, scheme
		service.save!
	  bonus = Bonus.where(['service_id = ? AND bonus_scheme_id = ? ', service.id, scheme.id]).first
	  bonus.value.should eq(scheme.value)
	  Bonus.statuses.invert[bonus.eligibility].should eq(:potential)		
	end
	
  describe "#grant_bonus" do

   	before(:all) do
  		@project_conversion_scheme = FactoryGirl.create :bonus_scheme, :conversion 
			@ws_sold_scheme = FactoryGirl.create :bonus_scheme, :ws
			@ux_sold_scheme = FactoryGirl.create :bonus_scheme, :ux
  	end
 
  	context "when service is potential" do

  		subject(:service) { FactoryGirl.build(:service, :with_project,
						consultant: @issa_consultant,
						sales_force: @max_consultant,
						service_type: @ws_service)
  		}

	  	it "registers potential conversion bonus" do
	  		service.update_attributes(:success_status => Service.statuses[:in_progress])
	  		service.project.converted = Project.conversion_status[:pending]
	  		get_bonus(service, @project_conversion_scheme)
	  	end

	  	it "registers potential service sale bonus" do
	  		service.update_attributes(:is_paid => false)
	  		get_bonus(service, @ws_sold_scheme)
	  	end
 
	  	context "when project is won" do

	  		before do
	  			service.project.converted = Project.conversion_status[:won]
	  			service.service_type = @ws_service
	  			service.start_date = '01/06/2013'
		  		service.save	  		
		  		bonuses = Bonus.where(['user_id IN (?) AND service_id = ?', [service.consultant.id, service.sales_force.id], service.id])
		  		bonuses.map(&:destroy)
	  		end

	  		subject { service.grant_bonus } #who_got_bonus
	  		it { should have_key(service.consultant.name) }
	  		it { subject[service.consultant.name].should have_key('conversion') }
	  		it { subject.should have_key(service.sales_force.name) }
	  		it { subject[service.sales_force.name].should_not have_key('conversion') }
	  		it { subject[service.sales_force.name].should have_key('ws') }

	  	end
  	end

  	context "when a service or project is won" do

  		before do
  			@project = FactoryGirl.create(:project, converted: Project.conversion_status[:won]) 
   		end

   		subject(:service) {
   			FactoryGirl.build(:service, :with_project,
					project: @project,
					consultant: @issa_consultant,
					sales_force: @max_consultant,
					service_type: @ws_service,
					success_status: Service.statuses[:completed],
					skip_grant_bonus_callback: true)
   		} 

   		def check_bonus_registered service, is_paid, scheme, status, who = :sales_force
		  		service.is_paid = is_paid
		  		service.save
		  		if who == :sales_force
		  			who_gets_the_bonus = service.sales_force
		  		elsif who == :consultant
		  			who_gets_the_bonus = service.consultant
		  		end		
		  		bonus = service.register_bonus scheme, who_gets_the_bonus
		  		bonus.value.should eq(scheme.value)
		  		bonus.eligibility.should eq(Bonus.statuses[status.to_sym])   			
   		end

  		# A WS doesn't need to be paid for the bonus to be registered if the project is WON
	  	it "registers a due conversion bonus for a won project" do
	  		#get_bonus service, @project_conversion_scheme
	  		check_bonus_registered service, true, @project_conversion_scheme, :won, :consultant		
	  	end

	  	context "when a workshop service exists for project" do
	  		it "registers a potential service bonus for the sales person" do
	  			check_bonus_registered service, false, @ws_sold_scheme, :potential
	  		end
	  		it "registers a due service bonus for the sales person" do
	  			check_bonus_registered service, true, @ws_sold_scheme, :won
		  	end

	  	end
	  
	  	context "when a ux service exists for project" do
	  		before do
	  			service.service_type = @ux_service
	  		end
	  		it "registers a potential service bonus for the sales person" do
	  			check_bonus_registered service, false, @ux_sold_scheme, :potential
	  		end
	  		it "registers a due service bonus for the sales person" do
	  			check_bonus_registered service, true, @ux_sold_scheme, :won
		  	end
	  	end 
	end

	context "When a project is lost" do
  		before do
   			@project = FactoryGirl.create(:project, 
   								converted: Project.conversion_status[:lost], 
   								status_comment: "Damit!") 
  		end

  		subject(:service) {
  			service = FactoryGirl.create(:service,
					project: @project,
					consultant: @issa_consultant,
					sales_force: @max_consultant,
					service_type: @ws_service,
					success_status: Service.statuses[:completed],
					skip_grant_bonus_callback: false
				)
  		}
	  	it "marks a potential conversion bonus as lost" do
	  		bonus = Bonus.where(['service_id = ? AND bonus_scheme_id = ? AND user_id = ?', service.id, @project_conversion_scheme.id, service.consultant.id]).first
	  		bonus.eligibility.should eq(Bonus.statuses[:lost])
	  	end
  	end
  end

  describe "#get_monthly_projects" do
  	
  	before do
  		@services = FabricateServices.new(@ws_service, :potential, @issa_consultant, 72, (2013..2013)).with_monthly_dist
   		#FabricateServices.new(@ws_service, @max_consultant, 72, (2011..2011)).with_monthly_dist 
  	end

  	context "when 'Workshop Pipeline' is selected" do
  		let (:filters) {{:service_type => @ws_service.key_name, :consultant => @issa_consultant.id, :year => 2013}}
  		subject(:potential_services) { Service.new.get_monthly_potential_services filters }

  		it "retrieves an object of 12 main elements" do
				potential_services.count.should eq(12)
  		end

  		it "total created" do
  			@services.total_created.should eq(72)
  		end

  		it "retrieves 3 potential services for each month" do
  			potential_services.each do |service| 
					#list << num_of_projects_per_month(month, projects)}
					service.should eq(6)
			  end
			end

			context "when 'Revenue' is selected" do

				let (:filters) {{:service_type => @ws_service.key_name, :consultant => @issa_consultant.id, :year => 2013}}
  			subject(:potential_services) { Service.new.get_monthly_potential_services filters }				
				it "retrieves an object of 12 main elements" do

				end


			end
  	end
  end
end