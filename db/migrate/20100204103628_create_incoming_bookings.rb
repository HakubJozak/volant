class CreateIncomingBookings < ActiveRecord::Migration
  def self.up
    create_table :bookings do |t|
      t.references :workcamp
      t.references :organization
      t.references :country
      t.column :gender, :string, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :bookings
  end
end
