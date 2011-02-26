class CreateWorkcampAssignments < ActiveRecord::Migration
  def self.up
    create_table :workcamp_assignments do |t|
      t.integer :apply_form_id
      t.integer :workcamp_id
      t.integer :order, :null => false
      t.datetime :accepted
      t.datetime :rejected
      t.datetime :asked
      t.datetime :infosheeted

      t.timestamps
    end
  end

  def self.down
    drop_table :workcamp_assignments
  end
end
