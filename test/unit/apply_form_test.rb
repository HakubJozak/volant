require 'test_helper'

class ApplyFormTest < ActiveSupport::TestCase

  context "Apply form" do
    setup do
      5.times { Factory.create(:apply_form, :created_at => Date.new(2008,2,2) ) }      
    end

    should "use years named scope" do
      ApplyForm.year(2008)
    end
  end

end
