require 'test_helper'

class VefXmlAttachmentTest < ActiveSupport::TestCase

  setup do
    form = Factory.create(:paid_form, firstname: 'Tom', lastname: 'Thomas')
    @attachment = VefXmlAttachment.new(apply_form: form)
  end

  test "#data" do
    assert_not_nil @attachment.data
  end

  test '#filename' do
    assert_equal 'VEF_SDA_tom_thomas.xml',@attachment.filename
  end


end

# == Schema Information
#
# Table name: attachments
#
#  id            :integer          not null, primary key
#  file          :string(255)
#  type          :string(255)      default("Attachment"), not null
#  message_id    :integer
#  created_at    :datetime
#  updated_at    :datetime
#  workcamp_id   :integer
#  apply_form_id :integer
#
