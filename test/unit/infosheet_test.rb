require 'test_helper'

class InfosheetTest < ActiveSupport::TestCase
  context "Infosheet" do
    should "create infosheet" do
      assert_raises(ActiveRecord::RecordInvalid) {  Infosheet.create! }
    end
  end
end
