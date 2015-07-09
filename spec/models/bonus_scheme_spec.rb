require 'spec_helper'

describe BonusScheme do
  
  before(:each) do
    @scheme = BonusScheme.create(:reason => 'Project Conversion', :value => 200, :key_name => 'conversion')
  end

  it "should find by key_name" do
    get_scheme = BonusScheme.get_scheme @scheme.key_name
    get_scheme.key_name.should eq(@scheme.key_name)
  end
end