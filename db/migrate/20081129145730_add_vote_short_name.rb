class AddVoteShortName < ActiveRecord::Migration
  def self.up
    add_column :votes, :short_name, :string
  end

  def self.down
    remove_column :votes, :short_name
  end
end
