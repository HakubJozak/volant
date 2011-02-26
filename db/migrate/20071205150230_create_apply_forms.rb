class CreateApplyForms < ActiveRecord::Migration
  def self.up
    create_table :apply_forms do |t|
      t.column :volunteer_id, :integer
      t.column :fee, :decimal, :scale => 2, :precision => 10,
                     :null => false, :default => 2200

      t.column :cancelled, :datetime
      t.column :general_remarks, :text
      t.column :motivation, :text
      t.timestamps
    end
  end

  def self.down
    drop_table :apply_forms
  end

end

