class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :to
      t.string :from
      t.string :subject
      t.text :body
      t.string :action

      t.integer :user_id, null: false
      t.integer :email_template_id
      t.integer :workcamp_assignment_id

      t.datetime :sent_at
      t.timestamps
    end

    add_column :apply_forms, :message_id, :integer
  end
end
