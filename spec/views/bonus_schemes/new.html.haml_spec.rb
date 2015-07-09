require 'spec_helper'

describe "bonus_schemes/new" do
  before(:each) do
    assign(:bonus_scheme, stub_model(BonusScheme,
      :reason => "MyString",
      :value => 1.5
    ).as_new_record)
  end

  it "renders new bonus_scheme form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => bonus_schemes_path, :method => "post" do
      assert_select "input#bonus_scheme_reason", :name => "bonus_scheme[reason]"
      assert_select "input#bonus_scheme_value", :name => "bonus_scheme[value]"
    end
  end
end
