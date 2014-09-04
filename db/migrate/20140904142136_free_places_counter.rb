class FreePlacesCounter < ActiveRecord::Migration
  def change
    add_column :workcamps, :free_places, :integer, default: 0, null: false
    add_column :workcamps, :free_places_for_males, :integer, default: 0, null: false
    add_column :workcamps, :free_places_for_females, :integer, default: 0, null: false
  end
end
