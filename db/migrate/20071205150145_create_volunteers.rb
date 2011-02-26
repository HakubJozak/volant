class CreateVolunteers < ActiveRecord::Migration
  def self.up
    create_table :volunteers do |t|
      t.column :firstname, :string, :null => false
      t.column :lastname, :string, :null => false
      t.column :gender, :string, :null => false

      t.integer :old_schema_key

      # should be :null => false but data are not consistent!
      t.column :email, :string
      t.column :phone, :string

      t.column :birthdate, :date
      t.column :birthnumber, :string

      t.column :nationality, :string
      t.column :occupation, :string

      # should be :null => false but data are not consistent!
      t.column :address, :text
      t.column :contact_address, :text

      t.column :account, :string

      t.column :emergency_name, :string
      t.column :emergency_day, :string
      t.column :emergency_night, :string

      t.column :speak_well, :string
      t.column :speak_some, :string
      t.column :special_needs, :text
      t.column :past_experience, :text
      t.column :comments, :text

      t.timestamps
    end
  end

  def self.down
    drop_table :volunteers
  end
end
