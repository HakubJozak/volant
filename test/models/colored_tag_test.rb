require 'test_helper'

class ColoredTagTest < ActiveSupport::TestCase

  test "color code validation" do
    tag = ColoredTag.new(name: 'some tag', :color => '#990000', :text_color => '#788ade')
    assert tag.valid?, "Tag #{tag.inspect} is invalid"
#    assert_invalid Tag.new( @commons.update( :color => '#990000', :text_color => '#788ade'))
  end
end
