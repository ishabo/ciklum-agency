require 'spec_helper'
describe ApplicationController do

  def valid_attributes
    position = stub_model(Position, :name => 'Technical Business Consultant')
    {:name => 'Issa Shabo', :email => 'iss@ciklum.com', :password => 'test', :position_id => 1, :position => position}
  end

end