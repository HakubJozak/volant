class AddAccountIdToUser < ActiveRecord::Migration
  def change
    add_column :devise_users, :account_id, :integer
    User.reset_column_information
    User.update_all account_id: Account.first.id
  end
end
