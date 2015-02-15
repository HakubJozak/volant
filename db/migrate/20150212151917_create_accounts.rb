class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.integer :organization_id
      t.date :season_start
      t.integer :organization_response_limit
      t.integer :infosheet_waiting_limit

      t.timestamps
    end

    Account.create!(organization: Organization.find_by_code('SDA'),
                    organization_response_limit: 4,
                    infosheet_waiting_limit: 30,
                    season_start: Date.new(2015,3,15))
  end
end
