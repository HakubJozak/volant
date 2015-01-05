class NewEmailTemplates < ActiveRecord::Migration
  def change
    create_table :new_email_templates do |t|
      t.string   :action
      t.string   :title
      t.string   :to
      t.string   :cc
      t.string   :bcc, default: '{{user.email}}'
      t.string   :from, default: '{{user.email}}'
      t.string   :subject
      t.text     :body
      t.timestamps
    end

    Adhoc::migrate_email_templates
  end
end
