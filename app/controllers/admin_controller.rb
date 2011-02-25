class AdminController < ApplicationController
  before_filter :authorize
  
  def index
    @admins = Admin.find(:all)
    @ldap = LdapInfo.find(:first) # and only
    @ldap = LdapInfo.new if @ldap.nil?
    @admin = Admin.new
    @ss_stats = SavedSearch.get_stats
    @user_tip_count = Tip.get_stats
    respond_to do |format|
      format.html
    end
  end
  
  def add_admin
    admin = Admin.new(params[:admin])
    if admin.save
      flash[:notice] = "#{params[:admin][:user]} added to list of administrators"
    else
      flash[:error] = ""
      admin.errors.each_full do |error|
        flash[:error] += error + "\n"
      end
    end
    redirect_to admin_path
  end
  
  def destroy
    if Admin.count > 1
      @admin = Admin.find(params[:id])
      @admin.destroy
      flash[:notice] = "#{@admin.user} removed from list of administrators"
    else
      flash[:error] = "There must be at least one admin user"
    end
    redirect_to admin_path
  end
  
  def save_ldap
    # If all of the parameters are empty, delete ldap_info
    ldap_info = params[:ldap_info]
    if ldap_info[:host].empty? || ldap_info[:prefix].empty? || ldap_info[:postfix].empty?
      LdapInfo.delete_all
      flash[:notice] = "Ldap information deleted"
    else
      if LdapInfo.count > 0
        LdapInfo.update(:first, ldap_info)
        flash[:notice] = "Ldap information updated"
      else
        LdapInfo.create(ldap_info)
        flash[:notice] = "Ldap information created"
      end
    end
    redirect_to admin_path
  end
  
  private
  def authorize
    if !session[:user_is_admin]
      flash[:error] = "You must be logged in as an admin to visit this page"
      redirect_to tips_path
      return
    end
    true
  end
end
