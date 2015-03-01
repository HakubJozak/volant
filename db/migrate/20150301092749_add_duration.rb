class AddDuration < ActiveRecord::Migration
  def change
    add_column :workcamps, :duration, :integer
  end
end
