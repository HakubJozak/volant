class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :file
      t.string :type, default: 'Attachment', null: false
      t.belongs_to :message
      t.timestamps
    end
  end
end
