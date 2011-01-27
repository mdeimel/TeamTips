class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # TODO create separate authentication controller
  def login
    if params[:username].nil? || params[:username].empty?
      flash[:error] = "You must enter a username"
    # If ldap is not setup, there will be no password
    elsif LdapInfo.setup?
      if LdapInfo.login params[:username], params[:password]
        set_current_user params[:username]
      else
        flash[:error] = "Username and password not accepted"
      end
    else
      set_current_user params[:username]
    end
    redirect_to tips_path
  end
  
  def logout
    session[:user] = nil
    redirect_to tips_path
  end
  
  private
  def set_current_user username
    session[:user] = username
    session[:user_is_admin] = !Admin.find_by_user(username).nil?
  end
end
