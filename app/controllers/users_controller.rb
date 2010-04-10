require 'digest/sha1'

class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update, :distroy]
  before_filter :require_admin, :only => [:list_users, :distroy_by_admin, :show_as_admin]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    @user.service_hash = Digest::SHA1.hexdigest(params[:user][:password] + 'unicon')
    if @user.save
      flash[:notice] = "Account registered!"
      redirect_back_or_default "users", "show"
    else
      render :action => :new
    end
  end
  
  def show
      @user = @current_user
  end

  def show_as_admin
      @user = User.find(params[:id])
  end

  def edit
    @user = @current_user
  end
  
  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end

  def distroy

  end

  def confirm_distroy
    User.delete @current_user.id
    flash[:notice] = "Account deleted!"
    redirect_to :controller => "home", :action => "index"
  end

  def distroy_by_admin
    @user_to_delete = User.find(params[:id])
    @deleted_users_name = @user_to_delete.login
    @user_to_delete.destroy
    flash[:notice] = "User #{@deleted_users_name} deleted!"
    redirect_to :controller => "users", :action => "list_users"
  end

  def personalized_home
    
  end

  #list all the registered users, only accsessible by a admin
  def list_users
    @users = User.all
  end

end
