module Outgoing::ImportedWorkcampsHelper

  def state_column(wc)
    icon( wc.state, nil, true)
  end

  def import_changes_column(wc)
    wc.import_changes.map do |change|
      Outgoing::Workcamp::human_attribute_name(change.field)
    end.join(',')
  end
end
