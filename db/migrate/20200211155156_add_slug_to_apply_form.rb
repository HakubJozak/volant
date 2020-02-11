class AddSlugToApplyForm < ActiveRecord::Migration
  def change
    add_column :apply_forms, :slug, :string, null: true

    add_index :apply_forms, :slug, unique: true
  end
end
