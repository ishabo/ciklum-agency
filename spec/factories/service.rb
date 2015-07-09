FactoryGirl.define do
  factory(:service) do
    budget [1500, 2500, 3000].sample
    created_by 1
    description nil
    duration [1, 2, 3].sample
    is_paid true
    proposal_sent true
    service_type_id 1
    sold_by 1
    spec_sent true
    start_date "2014-10-14"
    status_comment ""
    success_status 4
    user_id 1
    trait :with_project do
        project_id { FactoryGirl.create(:project).id }
    end
  end
end