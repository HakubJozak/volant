class CreateWorkcamps < ActiveRecord::Migration
  def self.up
    create_table :workcamps do |t|
      t.column :code, :string, :null => false
      t.column :name, :string, :null => false

      t.integer :old_schema_key

      t.column :country_id, :integer, :null => false
      t.column :organization_id, :integer, :null => false #, :on_delete => :cascade

      t.column :language, :string
      t.column :begin, :date
      t.column :end, :date

      t.column :capacity, :integer
      t.column :places, :integer, :null => false
      t.column :places_for_males, :integer, :null => false
      t.column :places_for_females, :integer, :null => false

      t.column :minimal_age, :integer, :null => false, :default => 18
      t.column :maximal_age, :integer, :null => false, :default => 99

      t.column :area, :text
      t.column :accomodation, :text
      t.column :workdesc, :text
      t.column :notes, :text
      t.column :description, :text

      t.timestamps
    end
  end

  def self.down
    drop_table :workcamps
  end
end
