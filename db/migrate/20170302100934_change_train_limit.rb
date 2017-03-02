class ChangeTrainLimit < ActiveRecord::Migration
  def change
    change_column :workcamps, :train, :string, limit: 4096
  end
end
