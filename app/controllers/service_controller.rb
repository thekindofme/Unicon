require 'digest/sha1'

class ServiceController < ApplicationController
  
  def contacts
    if(params[:username] != nil && params[:hash] != nil)
    
      @user = User.find_all_by_login(params[:username])[0]
      @password_sha1_hash = params[:hash]
      if (@user!=nil && @user.service_hash == @password_sha1_hash)
        @contacts = Contact.all_contacts @user.id
        render :xml => @contacts
        return
      end
    end

    render :xml => "<error>authentication failure</error>", :status => :unprocessable_entity
  end
end
