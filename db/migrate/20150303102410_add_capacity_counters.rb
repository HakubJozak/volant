class AddCapacityCounters < ActiveRecord::Migration
  def change
    add_column :workcamps, :free_capacity_males, :integer, default: 0, null: false
    add_column :workcamps, :free_capacity_females, :integer, default: 0, null: false
    add_column :workcamps, :free_capacity, :integer, default: 0, null: false    
  end
end
