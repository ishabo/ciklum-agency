FactoryGirl.define do
  factory(:bonus) do
    bonus_scheme_id 1
    claimed true
    due_month 8
    eligibility 2
    paid true
    payment_date "2013-02-19"
    project_id 16
    service_id 30
    user_id 1
    value 200.0
  end
end