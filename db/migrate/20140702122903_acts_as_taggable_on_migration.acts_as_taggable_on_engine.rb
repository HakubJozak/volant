# This migration comes from acts_as_taggable_on_engine (originally 1)
class ActsAsTaggableOnMigration < ActiveRecord::Migration
  def self.up
    add_column :taggings, :context, :string, limit: 128
    add_column :taggings, :tagger_id, :integer
    add_column :taggings, :tagger_type, :string
    # add_index :taggings, :tag_id
    # add_index :taggings, [:taggable_id, :taggable_type, :context]
  end

  def self.down
    remove_column :taggings, :context
    remove_column :taggings, :tagger_id
    remove_column :taggings, :tagger_type
  end
end
