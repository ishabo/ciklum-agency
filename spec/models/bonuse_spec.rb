require 'spec_helper'

describe Bonus do
  describe "Statuses" do
  	Bonus = Bonus.new
    it 'Has Potential status' do
  	  Bonus.statuses[1].should eq(:potential)
  	end
    it 'Has Won status' do
  	  Bonus.statuses[2].should eq(:won)
  	end
    it 'Has Lost status' do
  	  Bonus.statuses[3].should eq(:lost)
  	end  	
  end
end
