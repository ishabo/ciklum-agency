require 'spec_helper'

describe "users/index" do
  before(:each) do
    User.create! :name =>'Issa Shabo1', :email => 'iss1@ciklum.com', :password => 'qwerty', :position_id => 1
    User.create! :name =>'Issa Shabo2', :email => 'iss2@ciklum.com', :password => 'qwerty', :position_id => 1
    Position.create! :name =>'Technical Business Consultant'

    users = User.joins('LEFT JOIN positions p ON p.id = position_id').all
    assign(:users, users)
  end
  it "renders a list of users" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Issa Shabo1".to_s, :count => 1
    assert_select "tr>td", :text => "Issa Shabo2".to_s, :count => 1
    assert_select "tr>td", :text => "iss1@ciklum.com".to_s, :count => 1
    assert_select "tr>td", :text => "iss2@ciklum.com".to_s, :count => 1
    assert_select "tr>td", :text => "Technical Business Consultant".to_s, :count => 2
  end
  after(:each) do
    User.all.map(&:destroy)
    Position.all.map(&:destroy)
  end
end