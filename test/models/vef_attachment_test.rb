require 'test_helper'

class VefAttachmentTest < ActiveSupport::TestCase

  setup do
    form = Factory.create(:paid_form)
    @attachment = VefAttachment.new(apply_form: form)    
  end

  test "#data" do
    assert_not_nil @attachment.data
  end

  test '#filename' do
    assert_equal 'VEF_SDA_jakub_hozak.xml',@attachment.filename
  end


end
