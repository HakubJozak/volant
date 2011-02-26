module ModelAutoCompleterHelper
  def belongs_to_auto_completer(object, association, method, options={}, tag_options={}, completion_options={})
    real_object  = instance_variable_get("@#{object}")
    foreign_key  = real_object.class.reflect_on_association(association).primary_key_name

    tf_name  = "#{association}[#{method}]"
    tf_value = (real_object.send(association).send(method) rescue nil)
    # FIX for AS compatibility
    hf_name  = "#{object}[#{association}][id]"
    #hf_name  = "#{object}[#{foreign_key}]"


    hf_value = (real_object.send(foreign_key) rescue nil)
    options  = {
      :action => "auto_complete_belongs_to_for_#{object}_#{association}_#{method}"
    }.merge(options)
    model_auto_completer(tf_name, tf_value, hf_name, hf_value, options, tag_options, completion_options)
  end
end
