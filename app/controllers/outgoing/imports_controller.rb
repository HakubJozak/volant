class Outgoing::ImportsController < ApplicationController

  def new
  end

  def create
    if file = params[:pef_file]
      @report = []
      @wcs = Import::PefImporter.new(file).import! do |type,msg|
	@report << [type, msg]
      end

      render :action => :show
    else
      flash[:error] = t('import.missing_file')
      render :action => :new
    end
  end

end
