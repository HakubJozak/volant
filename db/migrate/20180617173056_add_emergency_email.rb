class AddEmergencyEmail < ActiveRecord::Migration
  def change
    rename_column :apply_forms, :emergency_night, :emergency_email
    rename_column :people, :emergency_night, :emergency_email    
  end
end
