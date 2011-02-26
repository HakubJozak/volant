class CreateInfosheets < ActiveRecord::Migration
  def self.up
    create_table :infosheets do |t|
      t.integer :workcamp_id
      t.string  :document_file_name
      t.string  :document_content_type
      t.integer :document_file_size
      t.datetime :document_updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :infosheets
  end
end
