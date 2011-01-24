class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # TODO create separate authentication controller
  def login
    if params[:username].nil? || params[:username].empty?
      flash[:error] = "You must enter a username"
    # If ldap is not setup, there will be no password
    elsif LdapInfo.setup?
      if LdapInfo.login params[:username], params[:password]
        session[:user] = params[:username]
      else
        flash[:error] = "Username and password not accepted"
      end
    else
      session[:user] = params[:username]
    end
    redirect_to tips_path
  end
  
  def logout
    session[:user] = nil
    redirect_to tips_path
  end
end
