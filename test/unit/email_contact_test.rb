require 'test_helper'

class EmailContactTest < ActiveSupport::TestCase

  test "validation" do
    assert_validates_presence_of  email_contacts(:seeds), :address
  end

end
