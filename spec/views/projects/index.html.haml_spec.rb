require 'spec_helper'

describe "projects/index" do
  before(:each) do
    assign(:projects, [
      stub_model(Projects,
        :name => "Name",
        :client => "Client",
        :project_manager => "Project Manager",
        :hub_id => 1,
        :sales_manager => "Sales Manager",
        :description => "MyText"
      ),
      stub_model(Projects,
        :name => "Name",
        :client => "Client",
        :project_manager => "Project Manager",
        :hub_id => 1,
        :sales_manager => "Sales Manager",
        :description => "MyText"
      )
    ])
  end

  it "renders a list of projects" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Client".to_s, :count => 2
    assert_select "tr>td", :text => "Project Manager".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Sales Manager".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
