# BonusScheme Model is used by the Bonus and Service Models to determine the 
# type of bonus and the value associated with any given bonus. The records are  
# borrowed by the Bonus Model, but they are not married to them. That means,
# any bonus created on the basis of a scheme before it's modified, the old value
# will have been captured by the Bonus object and stored in the bonus table
# and any changes to the bonus scheme will only affect future bonuses 

class BonusScheme < ActiveRecord::Base
  attr_accessible :reason, :value, :key_name

  def self.get_scheme keyword
  	BonusScheme.find_by_key_name(keyword)
  end

  def is_conversion?
  	key_name == 'conversion'
  end
end
