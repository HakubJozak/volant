class EnglishIntentions < ActiveRecord::Migration
  def self.up
    add_column :workcamp_intentions, :description_en, :string
  end

  def self.down
    remove_column :workcamp_intentions, :description_en
  end
end
