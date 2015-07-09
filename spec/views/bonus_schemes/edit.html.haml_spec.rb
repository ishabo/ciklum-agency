require 'spec_helper'

describe "bonus_schemes/edit" do
  before(:each) do
    @bonus_scheme = assign(:bonus_scheme, stub_model(BonusScheme,
      :reason => "MyString",
      :value => 1.5
    ))
  end

  it "renders the edit bonus_scheme form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => bonus_schemes_path(@bonus_scheme), :method => "post" do
      assert_select "input#bonus_scheme_reason", :name => "bonus_scheme[reason]"
      assert_select "input#bonus_scheme_value", :name => "bonus_scheme[value]"
    end
  end
end
