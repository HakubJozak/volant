class InfosheetsController < ApplicationController
  active_scaffold :infosheets do |config|
    config.columns = [ :created_at, :thumb, :document, :notes ]
    ban_editing(config, :thumb, :created_at)
  end
end
