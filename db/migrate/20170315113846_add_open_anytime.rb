class AddOpenAnytime < ActiveRecord::Migration
  def change
    add_column :workcamps, :variable_dates, :boolean
    
    (2000..2019).each do |year|
      from = Date.new(year, 1,1)
      to   = Date.new(year, 12, 31)

      Ltv::Workcamp.where(from: from).
        where("EXTRACT(DAY FROM \"end\") = 31 AND EXTRACT(MONTH FROM \"end\") = 12").
        update_all(variable_dates: true)
    end
  end
end
