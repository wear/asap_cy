class ChangeRatingToReview < ActiveRecord::Migration
  def self.up
    rename_column :ratings, :vendor_id, :review_id
    remove_column :ratings, :user_id
  end

  def self.down
    rename_column :ratings, :review_id, :vendor_id
    add_column :ratings, :user_id, :integer
  end
end
