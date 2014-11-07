require 'test_helper'

class ApplyFormTest < ActiveSupport::TestCase

  test "use years named scope" do
    ApplyForm.destroy_all
    3.times { Factory.create(:apply_form, created_at: Date.new(2008,2,2) ) }
    assert_equal 3, ApplyForm.year(2008).count
  end


end
