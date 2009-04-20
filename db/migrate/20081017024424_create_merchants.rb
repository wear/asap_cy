class CreateMerchants < ActiveRecord::Migration
  def self.up
    create_table :merchants do |t|
      t.string :name
      t.string :contact
      t.integer :tel
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :merchants
  end
end
