class AddIndexesMore < ActiveRecord::Migration
  def self.up
    add_index :workcamps, [ :state, :type, :begin ]
    add_index :workcamps, [ :state, :type ]
    add_index :workcamps, :type
    add_index :workcamps, :state
  end

  def self.down
    remove_index :workcamps, :column => [ :state, :type, :begin ]
    remove_index :workcamps, :column => [ :state, :type ]
    remove_index :workcamps, :type
    remove_index :workcamps, :state
  end
end
