class EmailTemplateData < ActiveRecord::Migration

  def self.up
    DataLoader.load_emails
  end

  def self.down
    EmailTemplate.delete_all
  end
end
