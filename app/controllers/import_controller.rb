class ImportController < ApplicationController
  def create
    wcs = Import::PefImporter.new(pef.read).import! do |level,msg|
      messages << { level: level, text: msg }
    end

    json = {
      import_messages: messages
    }

    render json: json
  end

  private

  def messages
    @messages ||= []
  end

  def pef
    params.require(:pef)
  end

end
