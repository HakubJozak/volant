class VolunteerPassportFields < ActiveRecord::Migration
  def change
    add_column :people, :passport_number, :string
    add_column :people, :passport_issued_at, :date
    add_column :people, :passport_expires_at, :date
  end
end
