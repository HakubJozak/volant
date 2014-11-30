class AddProjectIdToWorkcamps < ActiveRecord::Migration
  def change
    add_column :workcamps, :project_id, :string
  end
end
