class NewsArticle < ActiveRecord::Base
  #validation
  validates_presence_of :title, :body
end
