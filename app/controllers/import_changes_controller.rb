class ImportChangesController < ApplicationController
  helper :import_changes

  before_filter :find_import_change, :only => [ :apply ]

  active_scaffold :import_changes do |config|
    config.list.sorting = [ 'field' ]
    config.list.per_page = 9999

    config.actions.exclude :show, :update, :create, :search

    config.columns = [ :field, :old, :new, :diff ]

    config.action_links.add :apply,
      :label => help.icon('apply', ImportChange.human_attribute_name('apply'), true),
      :popup => false,
      :type => :record,
      :method => :post,
      :inline => true

  end

  def apply
    @change.apply!
    redirect_to :back
  end

  protected

  def find_import_change
    @change = ImportChange.find(params[:id])
  end

end
