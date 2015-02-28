class SeasonStartRename < ActiveRecord::Migration
  def change
    rename_column :accounts, :season_start, :season_end
  end
end
