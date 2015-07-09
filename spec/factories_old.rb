require 'factory_girl'

FactoryGirl.define do
  factory :project do
  	client 'Kenneth Bremer'
    description ''
    hub_id 111
    name 'ReelTrak'
    project_manager 'Alex Skydan'
    sales_manager 'Ida Holst'
    budget 130000
    converted Project.conversion_status[:pending]
    engagement_type Project.engagement_types[:project_delivery]
    status_comment ''
    abc Project.client_abc.invert['B']
  end

  factory :position do
    has_bonus true
    name 'Technical Business Consultant'
  end

  factory :user do
    name 'Issa Shabo'
    email 'iss@ciklum.com'
    position FactoryGirl.build(:position)
    is_admin true
    has_bonus true
    is_employed true
    is_manager false
    password 'blabla'
  end

  factory :service_type do 
    name 'Workshop'
    key_name 'ws'
  end

  factory :service do
    project FactoryGirl.build(:project)
    sales_force FactoryGirl.build(:user)
    consultant FactoryGirl.build(:user)
    duration '2'
    budget '3000'
    is_paid false
    status_comment ''
    service_type FactoryGirl.build(:service_type)
    success_status Service.statuses[:potential]
    start_date '01/06/2013'
  end

  factory :bonus_scheme do
    reason 'Project Conversion'
    value 200
    key_name 'conversion'
  end

end