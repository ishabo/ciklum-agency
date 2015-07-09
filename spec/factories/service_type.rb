FactoryGirl.define do
  factory(:service_type) do

  	trait :ws do
    	key_name "ws"
    	name "Workshop"
  	end
    
    trait :ux do
    	key_name "ux"
    	name "User Experience"    	
  	end
  	
    trait :ttr do
      key_name "ttr"
      name "Team & Technology Recommendation"      
    end    
  end
end