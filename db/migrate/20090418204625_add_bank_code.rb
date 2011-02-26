class AddBankCode < ActiveRecord::Migration
  def self.up
    add_column :payments, :bank_code, :string, :limit => 4
    add_column :payments, :spec_symbol, :string
    add_column :payments, :var_symbol, :string
    add_column :payments, :const_symbol, :string
    add_column :payments, :name, :string
  end

  def self.down
    remove_column :payments, :bank_code
  end
end
