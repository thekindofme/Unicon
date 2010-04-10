# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all
  helper_method :current_user_session, :current_user
  filter_parameter_logging :password, :password_confirmation

  #require the user to be logged in for every action in every controller unless
  #a certian controller overrieds this behavior
  #before_filter :require_user

  #make sure the top navigation gets populated after every and each controller action gets executed
  before_filter  :populate_top_navigation

  def initialize
    @title = "unicon - its all at one place!" #initialize the default title
  end

  private
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
    
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
    
  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  def require_admin
    unless current_user
      store_location
      flash[:notice] = "You must be logged in as a admin to access this page"
      redirect_to new_user_session_url
      return false
    end

    #ok the user is logged in, let's check whether he is a admin or not
    unless (current_user && current_user.is_admin?)
      flash[:notice] = "You must be logged in as a admin to access this page"
      redirect_to :controller => "home", :action => "index"
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to account_url
      return false
    end
  end
    
  def store_location
    session[:return_to] = request.request_uri
  end
    
  def redirect_back_or_default(controller, action)
    if (session[:return_to])
      redirect_to session[:return_to]
    else
      redirect_to :controller=>controller, :action=>action
    end

    #reset it
    session[:return_to] = nil
  end

  class NavigationItem

    def initialize(title, link, is_selected, position)
      self.title = title
      self.link = link
      self.is_selected = is_selected
      self.position = position
    end

    attr_accessor :title        #the title that will be displayed on the nav link/button
    attr_accessor :link         #the link
    attr_accessor :is_selected #is this item's link == curnent path?
    attr_accessor :position #the position of this item, in the navigation ex:(1,2,3,4...)

    def class_to_s
      self.class.to_s
    end

    #the order in wich this navigation item is displayed in the navigation
    include Comparable
    def <=>(other)
      self.position <=> other.position
    end

  end

  class NavigationToControllerActionItem < NavigationItem

    def initialize(title, is_selected, position, controller, action)
      self.title = title
      self.is_selected = is_selected
      self.position = position
      self.controller = controller
      self.action = action
    end

    attr_accessor :controller #is this item's link == curnent path?
    attr_accessor :action #is this item's link == curnent path?

  end

  class NavigationToResoureceMappedControllerActionItem < NavigationItem

    def initialize(title, link, is_selected, position, method, confim_message)
      self.title = title
      self.link = link
      self.is_selected = is_selected
      self.position = position
      self.method = method
      self.confim_message = confim_message
    end

    attr_accessor :method #is this item's link == curnent path?
    attr_accessor :confim_message #is this item's link == curnent path?

  end

  def populate_top_navigation
    @navigation_items = []
    
    if current_user
      if current_user.is_admin?
        @navigation_items << NavigationToControllerActionItem.new("Users", false, 30, "users", "list_users")
        @navigation_items << NavigationToControllerActionItem.new("News", false, 20, "news", "index")
        @navigation_items << NavigationToControllerActionItem.new("Site Statistics", false, 50, "site", "stats")
        @navigation_items << NavigationToControllerActionItem.new("Ads", false, 60, "advertisements", "index")
      else
        @navigation_items << NavigationToControllerActionItem.new("Contacts", false, 90, "contacts", "index")
        @navigation_items << NavigationToControllerActionItem.new("Contact Sources", false, 100, "contact_sources", "index")
      end
      
      @navigation_items << NavigationItem.new("My Account", account_path, false, 5000)
      @navigation_items << NavigationToResoureceMappedControllerActionItem.new("Logout", user_session_path, false, 10000, :delete, "Are you sure you want to logout?")
    else
      @navigation_items << NavigationItem.new("Register", new_account_path, false, 300)
      @navigation_items << NavigationItem.new("Log In", new_user_session_path, false, 200)
      @navigation_items << NavigationItem.new("Forgot password", new_password_reset_path, false, 400)
    end

    @navigation_items << NavigationToControllerActionItem.new("Home", false, 10, "home", "index")
  
    #for guest and users but not for admins
    if ((current_user && !current_user.is_admin?) || current_user == nil)
      @navigation_items << NavigationToControllerActionItem.new("Advertise!", false, 900, "advertisements", "new")
    end

    @navigation_items = @navigation_items.sort
  end
end
