class CreatePayments < ActiveRecord::Migration

  def self.up
    create_table :payments do |t|

      t.column :apply_form_id, :integer

      # will be removed
      # t.column :old_schema_key, :integer

      t.column :amount, :decimal, :scale => 2, :precision => 10, :null => false
      t.column :received, :date, :null => false
      t.column :description, :string, :limit => 1024
      t.column :account, :string

      # TODO - bank/cash - Paypal? - ciselnik?
      t.column :mean, :string, :null => false

      # TODO - + specificky symbol, variabilni ...?
      t.column :returned_date, :date
      t.column :returned_amount, :decimal, :scale => 2, :precision => 10
      t.column :return_reason, :string, :limit => 1024
    end
  end

  def self.down
    drop_table :payments
  end
end
