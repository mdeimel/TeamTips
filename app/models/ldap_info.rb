require "net/ldap"

class LdapInfo < ActiveRecord::Base
  def self.setup?
    @@setup ||= LdapInfo.count > 0
  end
  
  def self.login user, password
    # Can this be removed so a new connection is not made every time?
    ldap_info = LdapInfo.find(:first) # and only
    uid = ldap_info.prefix + user + ldap_info.postfix
    ldap = Net::LDAP.new
    ldap.host = ldap_info.host
    ldap.authenticate uid, password
    ldap.bind
  end
  
  private
  @@setup = nil
end
