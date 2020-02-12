class AddExternalIdToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :external_id, :string, null: true
  end
end
