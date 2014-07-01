class VefAttachment

  include VefHelper

  attr_reader :form

  def initialize(params)
    if ApplyForm === params
      @form = params
    else
      @form = ApplyForm.find(params[:form_id])
    end
  end

  def self.create_from_params(params)
    VefAttachment.new(params)
  end

  def form_fields
    [[ 'form_id', @form.id ]]
  end

  def to_label
    'VEF.html'
  end

  # TODO - use routes instead
  def to_link
    "/apply_forms/vef/#{@form.id}"
  end

  def content_type
    "text/html"
  end

  def generate_data
    YamlUtils::eval_erb_file "#{RAILS_ROOT}/app/views/outgoing/apply_forms/vef.html.erb", binding
  end
end
