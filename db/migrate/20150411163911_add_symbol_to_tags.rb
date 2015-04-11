class AddSymbolToTags < ActiveRecord::Migration
  def change
    add_column :tags, :symbol, :string
  end
end
