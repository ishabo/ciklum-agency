FactoryGirl.define do
  factory(:bonus_scheme) do
  	trait :conversion do
	    key_name "conversion"
	    reason "Project Conversion"
	    value 200.0
  	end

  	trait :ws do
	    key_name "ws"
	    reason "Sold Workshop"
	    value 100.0
  	end
  	
  	trait :ux do
	    key_name "ws"
	    reason "Sold UX"
	    value 100.0
  	end  
  end
end