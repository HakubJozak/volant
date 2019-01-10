class ImportController < ApplicationController
  rescue_from(ActionController::ParameterMissing) do |e|
    if e.param == :pef
      render status: 422, text: 'PEF file missing'
    else
      raise
    end
  end

  def create
    wcs = Import::PefImporter.new(pef.read,clazz).import! do |level,msg|
      messages << { level: level, text: msg }
    end

    render json: { import_messages: messages  }
  end

  def confirm_all
    clazz.import_all!
    head :no_content
  end

  def cancel_all
    clazz.cancel_all_import!
    head :no_content
  end

  private

  def clazz
    workcamp_type(params[:type])
  end

  def messages
    @messages ||= []
  end

  def pef
    params.require(:pef)
  end

end
