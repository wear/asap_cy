class CreateMobileUsers < ActiveRecord::Migration
  def self.up
    create_table :mobile_users do |t|
      t.string :mobile

      t.timestamps
    end
  end

  def self.down
    drop_table :mobile_users
  end
end
