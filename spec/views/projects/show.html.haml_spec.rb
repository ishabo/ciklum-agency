require 'spec_helper'

describe "projects/show" do
  before(:each) do
    @projects = assign(:project, stub_model(Projects,
      :name => "Name",
      :client => "Client",
      :project_manager => "Project Manager",
      :hub_id => 1,
      :sales_manager => "Sales Manager",
      :description => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Client/)
    rendered.should match(/Project Manager/)
    rendered.should match(/1/)
    rendered.should match(/Sales Manager/)
    rendered.should match(/MyText/)
  end
end
