class Outgoing::ImportedWorkcampsController < ::WorkcampsController
  active_scaffold 'Outgoing::Workcamp' do |config|
    config.list.label = I18n.t('import.title')
    config.list.sorting = { :created_at => :asc }
    config.list.columns = [ :country, :organization, :code, :name,
                            :tags, :begin, :end ]
    config.update.label = "Potvrdit import"
    config.update.link.label = "Potvrdit import"
#    config.update.refresh_list = true
  end

  protected

  def before_update_save(wc)
    wc.state = nil
  end


  def conditions_for_collection
    [ "state = 'imported'" ]
  end

end
