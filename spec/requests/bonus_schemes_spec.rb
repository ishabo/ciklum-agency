require 'spec_helper'

describe "BonusSchemes" do
  describe "GET /bonus_schemes" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get bonus_schemes_path
      response.status.should be(200)
    end
  end
end
