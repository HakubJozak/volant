# -*- coding: utf-8 -*-
require 'test_helper'

class EmailTemplateTest < ActiveSupport::TestCase

  test "#apply" do
    form = Factory(:apply_form)
    form.volunteer.update_columns(email: 'you@there.com')
    form.add_workcamp(Factory(:outgoing_workcamp,name: 'Name',code: 'CODE', begin: Date.new(2014,12,12), end: Date.new(2015,1,1)))

    tmpl = EmailTemplate.new(subject: 'Zprava o prijeti',
                             to: '{{volunteer.email}}',
                             from: 'info@inexsda.cz',
                             bcc: 'info@inexsda.cz',
                             body: "<p>Milá zájemkyně/ milý zájemce,</p>\n {{{workcamps_list}}}")

    email = tmpl.call(form)

    assert_equal 'you@there.com',email.to
    assert_equal 'info@inexsda.cz',email.from
    assert_equal 'Zprava o prijeti',email.subject
    body = "<p>Milá zájemkyně/ milý zájemce,</p>\n <ol><li>CODE - Name, 2014-12-12 - 2015-01-01</li></ol>"
    assert_equal body,email.body
  end

end

# == Schema Information
#
# Table name: new_email_templates
#
#  id         :integer          not null, primary key
#  action     :string(255)
#  title      :string(255)
#  to         :string(255)
#  cc         :string(255)
#  bcc        :string(255)      default("{{user.email}}")
#  from       :string(255)      default("{{user.email}}")
#  subject    :string(255)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#
