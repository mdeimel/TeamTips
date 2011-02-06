class Admin < ActiveRecord::Base
  validates_uniqueness_of :user#, :message => "Admin with that user already exists"
  validates_presence_of :user#, :message => "Admin must container username"
end
