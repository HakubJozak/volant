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
