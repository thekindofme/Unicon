class SiteController < ApplicationController
  def stats
    @no_of_users = User.all.size
    @no_of_news_articales = NewsArticle.all.size
    @no_of_ads = Advertisement.all.size
    @no_of_contacts = Contact.all.size
    @no_of_contact_sources = ContactSource.all.size
  end
end
