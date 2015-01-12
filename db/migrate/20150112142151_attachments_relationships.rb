class AttachmentsRelationships < ActiveRecord::Migration
  def change
    add_column :attachments, :workcamp_id, :integer
    add_column :attachments, :apply_form_id, :integer    
  end
end
