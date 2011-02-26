require 'test_helper'


class ApplyFormMailTest < ActiveSupport::TestCase

  def setup
    @form = Factory.create(:accepted_form)
    @user = users(:quentin)
    DataLoader.load_emails
  end

  def test_mails_to_volunteer
    [ :accept, :reject, :submitted, :infosheet ].each do |action|
      mail = ApplyFormMail.new(:action => action, :form => @form, :user => @user)
      assert_equal @form.volunteer.email, mail.to
      assert_equal 'quentin@example.com', mail.from
      assert_equal false, mail.body.blank?, "Body is blank"
      assert_equal false, mail.subject.blank?, "Subject is blank"
    end
  end

  def test_ask_mail
    mail = ApplyFormMail.new(:action => :ask, :form => @form, :user => @user)
    assert_equal @form.current_workcamp.organization.email, mail.to
    assert_equal 'quentin@example.com', mail.from
  end

#   test "parameter replacement in the email template" do
#     tmpl = Factory.create(:email_template, :subject => '{{wc.name}}')
#     assert_equal tmpl.subject, 'Kytlice'
#   end


end
