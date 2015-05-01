class AddConfirmedColumn < ActiveRecord::Migration
  def change
    add_column :workcamp_assignments, :confirmed, :datetime
  end
end
