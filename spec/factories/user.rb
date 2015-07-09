FactoryGirl.define do
  factory(:user) do

    trait :issa do
        name "Issa Shabo"
        position_id 1
        email "issa@ciklum.com"
        is_admin true
    end
    trait :max do
        name "Maxim Evdukimov"
        position_id 1
        email "maev@ciklum.com"
        is_admin false
    end

    trait :employed do
        is_employed true
    end

    trait :unemployed do
        is_employed false
    end
    has_bonus true
    is_manager false
    password 123
    avail_date "Now!"    
  end
end