class AddHtmlBodyToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :html_body, :text
  end
end
