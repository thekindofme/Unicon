class Advertisement < ActiveRecord::Base
  #validation
  validates_presence_of :link, :description

end
