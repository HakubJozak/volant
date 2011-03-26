class Outgoing::ImportedWorkcampsController < ::WorkcampsController
  active_scaffold 'Outgoing::Workcamp' do |config|
    config.list.sorting = { :created_at => :asc }
    config.list.columns = [ :country, :organization, :code, :name,
                            :tags, :begin, :end ]

  end

  def conditions_for_collection
    [ "state = 'imported'" ]
  end

end
