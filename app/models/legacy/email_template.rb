class Legacy::EmailTemplate < ActiveRecord::Base

  self.table_name = 'email_templates'

  def initialize(options = {})
    super(options)
  end

  def get_subject
    replace_keys(self.subject)
  end

  def get_body
    result = replace_keys(self.body)

    if wrapped_in
      @data ||= {}
      @data["content"] = result
      result = replace_keys(self.wrapped_in.body)
    end

    result
  end

  def wrapped_in
    unless wrap_into_template.blank?
      EmailTemplate.find_by_action(wrap_into_template)
    end
  end

  def to_label
    I18n.translate("model.apply_form_actions.#{action}")
  end

  # Bind data in a way 'object_key.its_method = value_returned_by_method'
  # used during the replacement. Methods are guessed from the AR object
  # and joined with the supplied group.
  def bind_data(name, object, methods = [])
    methods.concat(object.class.column_names)
    @data ||= {}

    methods.each do |method|
      @data["#{name}.#{method.to_s}"] = object.send(method)
    end
  end

  private

  def replace_keys(text)
    text.gsub(/\{\{([a-z]*\.?[a-z_]*)\}\}/) { |s| @data[$1] }
  end

end
