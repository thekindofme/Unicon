class HomeController < ApplicationController

  #override the default behaviour and let users access specified action without any authentication
  #before_filter :require_user, :except => [:index, :about, :help, :watch_demo, :try_app_in_a_sandbox]

  def index
    if current_user
      if current_user.is_admin?
        redirect_to(:controller=>"admin", :action=>"index")
      else
        #flash[:notice] = "Howdy, #{current_user.login}!. you are succesfully logged in"
        redirect_to(:controller=>"users", :action=>"personalized_home")
      end
    else
      #facilitate logining in from the home page it self
      @user_session = UserSession.new
    end

    #facilitate the use of special visual styles..etc for the defualt home page
    @is_home = true;
  end

  def about
  end

  def help
  end

  def faq
    
  end

  def clients

  end

  def watch_demo
  end

  def contact
  end

end
