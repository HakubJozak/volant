# -*- coding: utf-8 -*-
class Outgoing::ImportedWorkcampsController < ::WorkcampsController
  active_scaffold 'Outgoing::Workcamp' do |config|
    config.list.label = I18n.t('import.title')
    config.list.sorting = { :created_at => :asc }
    config.list.columns = [ :state, :country, :organization, :code, :name,
                            :import_changes ]
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

    config.action_links.add :cancel,
      :label => help.icon('cancel', 'Stornovat vše'),
      :type => :table,
      :method => :post,
      :position => :replace,
      :confirm => I18n::translate('import.delete_all'),
      :inline => false

  end

  def confirm
    Outgoing::Workcamp.import_all!
    redirect_to :back
  end

  def cancel
    Outgoing::Workcamp.cancel_import!
    redirect_to :back
  end


  protected

  def before_update_save(wc)
    wc.state = nil
  end


  def conditions_for_collection
    # TODO: DRY with model
    [ "state = 'imported' OR state = 'updated'" ]
  end

end
