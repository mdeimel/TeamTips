module ApplicationHelper
  def ldap_setup?
    LdapInfo.setup?
  end
  
  def loggedin?
    if session[:user].nil?||session[:user].empty?
      return false
    end
    return true
  end
  
  def set_focus_to_id id
    javascript_tag("$('#{id}').focus()")
  end
end
