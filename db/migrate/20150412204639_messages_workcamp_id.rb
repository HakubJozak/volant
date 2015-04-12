class MessagesWorkcampId < ActiveRecord::Migration
  def change
    rename_column :messages, :workcamp_assignment_id, :workcamp_id
  end
end
