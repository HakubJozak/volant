class AddApplyFormToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :apply_form_id, :integer
  end
end
