require 'spec_helper'

describe "bonus_schemes/index" do
  before(:each) do
    assign(:bonus_schemes, [
      stub_model(BonusScheme,
        :reason => "Reason",
        :value => 1.5
      ),
      stub_model(BonusScheme,
        :reason => "Reason",
        :value => 1.5
      )
    ])
  end

  it "renders a list of bonus_schemes" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Reason".to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
  end
end
