module EmailContactsHelper

  def kind_form_column(contact, input_name)
    options = [[ EmailContact.human_attribute_name('kind_outgoing'), 'OUTGOING' ],
               [ EmailContact.human_attribute_name('kind_incoming'), 'INCOMING' ],
               [ EmailContact.human_attribute_name('kind_off'), nil ] ]
    select_tag( input_name, options_for_select(options, contact.kind ))
  end

end
