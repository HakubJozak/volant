class RenameAccomodation < ActiveRecord::Migration
  def change
    rename_column :workcamps, :accomodation, :accommodation
  end
end
