class AddConfirmedToAf < ActiveRecord::Migration
  def self.up
    add_column :apply_forms, :confirmed, :datetime
  end

  def self.down
    remove_column :apply_forms, :confirmed
  end
end
