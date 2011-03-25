class LongitudeAndLatitude < ActiveRecord::Migration
  def self.up
    add_column :workcamps, :longitude, :decimal, :precision => 11, :scale => 7
    add_column :workcamps, :latitude, :decimal, :precision => 11, :scale => 7
  end

  def self.down
    remove_column :workcamps, :longitude
    remove_column :workcamps, :latitude
  end
end
