module TagsHelper

  def tag_name_column(record)
    TaggableHelper::render_tag(record)
  end

  def color_form_column(record,input_name)
    locals =  { :record => record, :field => 'color' }
    render :partial => 'color_picker', :locals => locals
  end

  def text_color_form_column(record,input_name)
    locals =  { :record => record, :field => 'text_color' }
    render :partial => 'color_picker', :locals => locals
  end


end
