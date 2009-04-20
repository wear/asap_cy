class CreateCommissions < ActiveRecord::Migration
  def self.up
    create_table :commissions do |t|
      t.references :booking
      t.integer :booking_charge
      t.integer :official
      t.integer :user
      t.boolean :valid

      t.timestamps
    end
  end

  def self.down
    drop_table :commissions
  end
end
