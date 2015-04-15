class AddExpiresAtToBookings < ActiveRecord::Migration
  def change
    add_column :bookings,:expires_at,:date
  end
end
