class WorkcampSearchIndex < ActiveRecord::Migration
  def self.up
    add_index :workcamps, [ :country_id, :begin ]
    add_index :workcamps, :begin
  end

  def self.down
    remove_index :workcamps,[ :country_id, :begin ]
    remove_index :workcamps, :begin
  end
end
