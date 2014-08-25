require 'test_helper'


class ApplyFormSerializerTest < ActiveSupport::TestCase

  def setup
    @form = Factory.create(:accepted_form)
  end

  def test_as_json
    serializer = ApplyFormSerializer.new(@form)
    assert_not_nil serializer.as_json
  end
end
