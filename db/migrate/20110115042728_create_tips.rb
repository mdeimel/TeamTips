class CreateTips < ActiveRecord::Migration
  def self.up
    create_table :tips do |t|
      t.text :content
      t.string :user
      t.integer :pageloads, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :tips
  end
end
