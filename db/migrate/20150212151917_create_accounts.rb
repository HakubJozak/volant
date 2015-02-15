class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.integer :organization_id, null: false
      t.date :season_start, default: Date.new(2015,3,15), null: false
      t.integer :organization_response_limit, default: 4, null: false
      t.integer :infosheet_waiting_limit, default: 30, null: false

      t.timestamps
    end

    Account.create!(organization: Organization.find_by_code('SDA'))
  end
end
