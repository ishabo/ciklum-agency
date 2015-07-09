require 'spec_helper'

describe "bonus_schemes/show" do
  before(:each) do
    @bonus_scheme = assign(:bonus_scheme, stub_model(BonusScheme,
      :reason => "Reason",
      :value => 1.5
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Reason/)
    rendered.should match(/1.5/)
  end
end
