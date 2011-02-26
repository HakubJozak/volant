class CreateIndices < ActiveRecord::Migration
  def self.up
    add_index :apply_forms, :id
    add_index :workcamps, :id
    add_index :volunteers, :id

    add_index :workcamp_assignments, :id
    add_index :workcamp_assignments, :apply_form_id
    add_index :workcamp_assignments, :asked
    add_index :workcamp_assignments, :accepted
    add_index :workcamp_assignments, :rejected
    add_index :workcamp_assignments, :infosheeted
  end

  def self.down
    remove_index :apply_forms, :id
    remove_index :workcamps, :id
    remove_index :volunteers, :id

    remove_index :workcamp_assignments, :id
    remove_index :workcamp_assignments, :apply_form_id
    remove_index :workcamp_assignments, :asked
    remove_index :workcamp_assignments, :accepted
    remove_index :workcamp_assignments, :rejected
    remove_index :workcamp_assignments, :infosheeted
  end
end
