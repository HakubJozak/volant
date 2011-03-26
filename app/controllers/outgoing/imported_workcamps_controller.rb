# -*- coding: utf-8 -*-
class Outgoing::ImportedWorkcampsController < ::WorkcampsController
  active_scaffold 'Outgoing::Workcamp' do |config|
    config.list.label = I18n.t('import.title')
    config.list.sorting = { :created_at => :asc }
    config.list.columns = [ :country, :organization, :code, :name,
                            :tags, :begin, :end ]
    config.update.label = "Potvrdit import"
    config.update.link.label = "Zkontrolovat"

    config.actions.exclude :create, :show

    config.action_links.add :confirm,
      :label => help.icon('confirm', 'Potvrdit vše'),
      :type => :table,
      :method => :post,
      :position => :replace,
      :confirm => I18n::translate('import.confirm'),
      :inline => false

  end

  def confirm
    Outgoing::Workcamp.import_all!
    redirect_to :back
  end

  protected

  def before_update_save(wc)
    wc.state = nil
  end


  def conditions_for_collection
    [ "state = 'imported'" ]
  end

end
