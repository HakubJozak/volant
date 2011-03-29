class ImportChangesController < ApplicationController
  helper :import_changes

  active_scaffold :import_changes do |config|
    config.columns = [ :field, :old, :new, :diff ]
  end

end
