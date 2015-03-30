class RefactorAttachments < ActiveRecord::Migration
  def change
    Attachment.where(type: 'VefAttachment').update_all(type: 'VefXmlAttachment')
    Attachment.where(type: 'Attachment').update_all(type: 'FileAttachment')
  end
end
