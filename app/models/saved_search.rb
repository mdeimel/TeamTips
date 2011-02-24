class SavedSearch < ActiveRecord::Base
  validates_presence_of :search, :ip
  
  def self.get_stats
    stats = Hash.new
    stats[:max] = SavedSearch.maximum("seconds")
    stats[:min] = SavedSearch.minimum("seconds")
    stats[:avg] = SavedSearch.average("seconds")
    stats
  end
end
