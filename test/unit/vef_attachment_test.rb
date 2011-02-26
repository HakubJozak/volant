require 'test_helper'

class VefAttachmentTest < ActiveSupport::TestCase
  context "VEF Attachment" do
    setup do
      @form = Factory.create(:paid_form)
    end

    should "generate data" do
      va = VefAttachment.new(@form)
      assert_not_nil va.generate_data
    end
  end

end
