class CreateEmailTemplates < ActiveRecord::Migration
  def self.up
    create_table :email_templates do |t|
      t.string :action
      t.string :description
      t.string :subject
      t.string :wrap_into_template, :default => 'mail'
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :email_templates
  end
end
