class ImportController < ApplicationController
  def create
    result = []

    Import::PefImporter.new(pef).import! do |level,msg|
      result << "#{level}: #{msg}"
    end

    render json: { result: result.join("\n") }
  end

  private

  def pef
    params.require(:pef)
  end

end
