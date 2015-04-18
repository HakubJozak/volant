class BookingGenderNullable < ActiveRecord::Migration
  def change
    change_column_null :bookings, :gender, true
  end
end
