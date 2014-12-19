class AddApplyFormIdToMessages < ActiveRecord::Migration
  def change
    remove_column :apply_forms, :message_id
  end
end
