class ChangeLimits < ActiveRecord::Migration
  def change
    [ :to, :from, :cc, :bcc ].each do |attr|
      change_column :messages, attr, :string, limit: 65536
    end

    change_column :workcamps, :region, :string, limit: 65536
  end
end
