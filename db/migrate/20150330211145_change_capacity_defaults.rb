class ChangeCapacityDefaults < ActiveRecord::Migration
  def change
    change_column_default(:workcamps, :capacity_males, 0)
    change_column_default(:workcamps, :capacity_females, 0)    
  end
end
