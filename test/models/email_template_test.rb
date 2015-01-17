# -*- coding: utf-8 -*-
require 'test_helper'

class EmailTemplateTest < ActiveSupport::TestCase

  test "#apply" do
    form = Factory(:apply_form)
    form.volunteer.update_columns(email: 'you@there.com')
    
    tmpl = EmailTemplate.new(subject: 'Zprava o prijeti',
                             to: '{{volunteer.email}}',
                             from: 'info@inexsda.cz',
                             bcc: 'info@inexsda.cz',
                             body: '<p>Milá zájemkyně/ milý zájemce,</p> {{{workcamps_list}}}')
    
    email = tmpl.call(form)
    assert_equal 'you@there.com',email.to
    assert_equal 'info@inexsda.cz',email.from
    assert_equal 'Zprava o prijeti',email.subject
    assert_equal '<p>Milá zájemkyně/ milý zájemce,</p> <ul></ul>',email.body
  end

end
