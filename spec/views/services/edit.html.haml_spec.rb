require 'spec_helper'

describe "services/edit" do
  before(:each) do
    @service = assign(:service, stub_model(Service,
      :type => "",
      :project_id => "MyString",
      :description => "MyText",
      :spec_sent => false,
      :proposal_sent => false,
      :duration => 1
    ))
  end

  it "renders the edit service form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => services_path(@service), :method => "post" do
      assert_select "input#service_type", :name => "service[type]"
      assert_select "input#service_project_id", :name => "service[project_id]"
      assert_select "textarea#service_description", :name => "service[description]"
      assert_select "input#service_spec_sent", :name => "service[spec_sent]"
      assert_select "input#service_proposal_sent", :name => "service[proposal_sent]"
      assert_select "input#service_duration", :name => "service[duration]"
    end
  end
end
