class CreateLdapInfos < ActiveRecord::Migration
  def self.up
    create_table :ldap_infos do |t|
      t.string :host
      t.string :prefix
      t.string :postfix

      t.timestamps
    end
  end

  def self.down
    drop_table :ldap_infos
  end
end
