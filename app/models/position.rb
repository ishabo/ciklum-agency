# Position Model is a grouping object for users
class Position < ActiveRecord::Base
  attr_accessible :has_bonus, :name, :abbr
end
