require 'spec_helper'

describe "projects/edit" do
  before(:each) do
    @projects = assign(:projects, stub_model(Projects,
      :name => "MyString",
      :client => "MyString",
      :project_manager => "MyString",
      :hub_id => 1,
      :sales_manager => "MyString",
      :description => "MyText"
    ))
  end

  it "renders the edit projects form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => projects_path(@projects), :method => "post" do
      assert_select "input#projects_name", :name => "projects[name]"
      assert_select "input#projects_client", :name => "projects[client]"
      assert_select "input#projects_project_manager", :name => "projects[project_manager]"
      assert_select "input#projects_hub_id", :name => "projects[hub_id]"
      assert_select "input#projects_sales_manager", :name => "projects[sales_manager]"
      assert_select "textarea#projects_description", :name => "projects[description]"
    end
  end
end
