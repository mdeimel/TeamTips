require "net/ldap"

class LdapInfo < ActiveRecord::Base
  def self.setup?
    @@setup ||= LdapInfo.count > 0
  end
  
  def self.login user, password
    @@ldap ||= connect_to_ldap
    user_account = @@ldap.prefix + user + @@ldap.postfix
    @@ldap.authenticate user_account, password
    @@ldap.bind
  end
  
  private
  @@setup = nil
  @@ldap = nil
  
  def self.connect_to_ldap
    ldap_info = LdapInfo.find(:first) # and only
    ldap = Net::LDAP.new
    ldap.host = ldap_info.host
    ldap.prefix = ldap_info.prefix
    ldap.postfix = ldap_info.postfix
    ldap
  end
end
