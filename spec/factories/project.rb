FactoryGirl.define do
  factory(:project) do
    abc (0..3).to_a.sample
    budget (20000..200000).to_a.sample
    sequence(:client)  { |n| "Client #{n}" } 
    sequence(:description)  { |n| "Project Description #{n}" } 
    engagement_type 1
    hub_id (1000..1999).to_a.sample
    sequence(:name)  { |n| "Project Name #{n}" } 
    project_manager ["Dmitry Kogan", "Alex Skydan", "Eugene Labunskiy", "Alex Kryuchkov"].sample
    sales_manager ["Arne Hansen", "Ida Holst", "Rob Dolan", "Andreas Ganswindt"].sample
    status_comment ""
    # after :create do |project|
        
    #     service = FactoryGirl.create :service_type, :ws
    #     FactoryGirl.create :service, 
    #                         project: project, 
    #                         consultant: FactoryGirl.create :user,
    #                         sales_force: FactoryGirl.create :user 
    #                         service_type: 
    # end
  end
end