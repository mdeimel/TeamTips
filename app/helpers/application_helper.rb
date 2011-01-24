module ApplicationHelper
  def ldap_setup?
    LdapInfo.setup?
  end
end
