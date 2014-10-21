class AddNameToDeviseUsers < ActiveRecord::Migration
  def change
    add_column :devise_users, :first_name, :string
    add_column :devise_users, :last_name, :string
  end
end
