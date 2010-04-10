# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  #navigation population
#  class NavigationItem
#
#    def initialize(title, link, is_selected)
#      self.title = title
#      self.link = link
#      self.is_selected = is_selected
#    end
#
#    attr_accessor :title        #the title that will be displayed on the nav link/button
#    attr_accessor :link         #the link
#    attr_accessor :is_selected #is this item's link == curnent path?
#  end

#  def self.populate_top_navigation_helper(any_user_is_logged_in)
#    navigation_items = []
#    if any_user_is_logged_in
#      navigation_items << NavigationItem.new("My Account", account_path, false)
#      navigation_items << NavigationItem.new("Logout", user_session_path, false)
#    else
#      navigation_items << NavigationItem.new("Register", new_account_path, false)
#      navigation_items << NavigationItem.new("Log In", new_user_session_path, false)
#      navigation_items << NavigationItem.new("Forgot password", new_password_reset_path, false)
#    end
#
#    return navigation_items
#  end

end
