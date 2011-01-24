class CreateSavedSearches < ActiveRecord::Migration
  def self.up
    create_table :saved_searches do |t|
      t.string :search
      t.float  :seconds
      t.string :user
      t.string :ip

      t.timestamps
    end
  end

  def self.down
    drop_table :saved_searches
  end
end
