class AddCcBccToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :cc, :string
    add_column :messages, :bcc, :string
  end
end
