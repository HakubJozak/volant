class AddAccountIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :account_id, :integer
    User.update_all account_id: Account.first.id
  end
end
