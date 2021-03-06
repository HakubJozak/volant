class ChangeOrganizationsCodes < ActiveRecord::Migration
  def self.up
    transaction do
      change('CSM','CSM')
      change('AI','Active International')
      change('Alli','ALLIANSSI')
      change('CAT','COCAT')
      change('CBB','CBB')
      change('CBF','CBF')
      change('CIEEJ','CIEEJ')
      change('CJ','CJ')
      change('CONC','Concordia France')
      change('CONCUK','Concordia UK')
      change('CPI','YAP Italia')
      change('ELIX','CVG')
      change('EST','EST-YES')
      change('FIYE','FIYE')
      change('GEN','Genctur')
      change('GSM','GSM')
      change('HUJ','HUJ')
      change('IBG','IBG')
      change('IJGD','IJGD')
      change('ISL','INEX Slovakia')
      change('JR','J&R')
      change('Leg','Legambiente')
      change('LUN','Lunaria')
      change('LYVS','LYVS')
      change('MS','MS')
      change('NICE','NICE')
      change('NIG','NIG')
      change('OH','Open Houses')
      change('PI','PRO International')
      change('SDA','INEX-SDA')
      change('SEEDS','SEEDS')
      change('SIW','SIW')
      change('SJV','SJ Vietnam')
      change('SR','VSS - YRS')
      change('SVI','SVI')
      change('U','UNAREC')
      change('UAALT','Alternative-V')
      change('UF','UNION FORUM')
      change('UNAS','UNA Exchange')
      change('VAP','YAP UK')
      change('VFP','VFP')
      change('VJF','VJF')
      change('WF','WF')
      change('WS','Workcamp Switzerland')
      change('YAPA','YAP Austria')
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end

  private

  def self.change(to,from)
    o = Organization.find_by_code(from)
    if o
      o.code = to
      o.save!
    end
  end
end
