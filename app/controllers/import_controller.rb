class ImportController < ApplicationController
  def create
    clazz = workcamp_type(params[:type])
    wcs = Import::PefImporter.new(pef.read,clazz).import! do |level,msg|
      messages << { level: level, text: msg }
    end

    render json: { import_messages: messages  }
  end

  private

  def messages
    @messages ||= []
  end

  def pef
    params.require(:pef)
  end

end
