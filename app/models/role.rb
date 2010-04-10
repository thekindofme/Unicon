class Role < ActiveRecord::Base
  #validation
  validates_presence_of :name
end
