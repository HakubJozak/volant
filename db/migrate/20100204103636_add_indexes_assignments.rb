class AddIndexesAssignments < ActiveRecord::Migration
  def self.up
    add_index :infosheets, :workcamp_id
    add_index :organizations, :id
    add_index :workcamp_assignments, :workcamp_id
  end

  def self.down
    remove_index :infosheets, :column => [ :workcamp_id ]
    remove_index :organizations, :column => [ :id ]
    remove_index :workcamp_assignments, :column => [ :workcamp_id ]
  end
end
