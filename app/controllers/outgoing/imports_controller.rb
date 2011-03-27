class Outgoing::ImportsController < ApplicationController

  def new
  end

  def create
    if file = params[:pef_file]
      importer = Import::PefImporter.new(file)
    elsif file = params[:sci_file]
      importer = Import::SciImporter.new(file)
    else
      flash[:error] = t('import.missing_file')
      render :action => :new
      return
    end

    @report = []

    importer.import! do |type,msg|
      @report << [type, msg]
    end

    render :action => :show
  end

end
