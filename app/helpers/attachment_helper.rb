module AttachmentHelper

  # TODO -
  def render_attachment(attachment)
    result = ''

    link = link_to(attachment.to_label, attachment.to_link, :popup => ['Attachment', 'height=600,width=600,scrollbar=1'])
    result << icon('attachment', link)

    result << hidden_field_tag('mail[attachments][][type]', attachment.class.to_s )
    result << hidden_field_tag('mail[attachments][][file]', '')

    attachment.form_fields.each do |name, value|
      result << hidden_field_tag("mail[attachments][][#{name}]", value )
    end

    result << remove_attachment_button
  end

  def add_attachment_button
    button_to_function t('emails.add_attachment'), "add_attachment(this, \"#{h(escape_javascript(empty_attachment))}\")"
  end

  def empty_attachment
    insides = ''
    insides << hidden_field_tag('mail[attachments][][type]', FileAttachment.to_s)
    insides << file_field_tag('mail[attachments][][file]', :class => 'text-input')
    # should be present not to break the array parameter handling
    # insides << hidden_field_tag('mail[attachments][][form_id]', :class => 'text-input')
    insides << remove_attachment_button
    as_field nil, insides
  end

  protected

  def remove_attachment_button
    link_to_function(icon('delete', t('emails.remove_attachment'), :hint_only => true),'remove_attachment(this)')
  end

end
