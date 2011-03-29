# -*- coding: utf-8 -*-
class Outgoing::UpdatedWorkcampsController < ApplicationController

  before_filter :find_workcamp, :only => [ :confirm ]

  active_scaffold 'Outgoing::Workcamp' do |config|
    config.list.label = I18n.t('import.updated_workcamps_title')
    config.list.sorting = { :created_at => :asc }
    config.list.columns = [ :state, :country, :organization, :code, :name,
                            :import_changes ]
    config.update.label = "Potvrdit import"

    config.actions.exclude :create, :show, :update, :delete

    config.action_links.add :cancel_all,
      :label => help.icon('cancel', 'Stornovat vše'),
      :type => :table,
      :method => :post,
      :position => :replace,
      :confirm => I18n::translate('import.update_all_confirm'),
      :inline => false

    config.action_links.add :confirm_all,
      :label => help.icon('apply', 'Aktualizovat všechny workcampy'),
      :type => :table,
      :method => :post,
      :position => :replace,
      :confirm => I18n::translate('import.confirm'),
      :inline => false

    config.action_links.add :confirm,
      :label => help.icon('apply', 'Aktualizovat'),
      :type => :record,
      :method => :post,
      :position => :replace,
      :inline => false

  end

  def confirm_all
    Outgoing::Workcamp.updated.import_all!
    redirect_to :back
  end

  def cancel_all
    Outgoing::Workcamp.updated.cancel_import!
    redirect_to :back
  end

  def confirm
    @workcamp.import!
    redirect_to :back
  end

  protected

  def find_workcamp
    @workcamp = Outgoing::Workcamp.updated.find(params[:id])
  end

  def conditions_for_collection
    # TODO: DRY with model
    [ "state = 'updated'" ]
  end

end
