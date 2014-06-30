require 'test_helper'

class EmailContactTest < ActiveSupport::TestCase

  test "validation" do
    contact = email_contacts(:seeds)
    assert_validates_presence_of  contact, :address
  end

end
