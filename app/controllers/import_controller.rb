class ImportController < ApplicationController
  def create
    result = []

    wcs = Import::PefImporter.new(pef.read).import! do |level,msg|
      result << "#{level}: #{msg}"
    end

    render json: Outgoing::Workcamp.where('state is not null'), each_serializer: WorkcampSerializer, root: 'workcamps'
  end

  private

  def pef
    params.require(:pef)
  end

end
