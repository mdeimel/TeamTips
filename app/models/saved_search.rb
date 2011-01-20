class SavedSearch < ActiveRecord::Base
  validates_presence_of :search, :ip
end
