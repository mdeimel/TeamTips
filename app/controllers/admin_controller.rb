class AdminController < ApplicationController
  def index
    if !session[:user_is_admin]
      flash[:error] = "You must be logged in as an admin to visit this page"
      redirect_to tips_path
      return
    end
    
    respond_to do |format|
      format.html
    end
  end
end
