class AddPassportFields < ActiveRecord::Migration
  def change
    add_column :apply_forms, :passport_number, :string
    add_column :apply_forms, :passport_issued_at, :date
    add_column :apply_forms, :passport_expires_at, :date   
  end
end
