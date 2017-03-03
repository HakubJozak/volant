require 'test_helper'

class ColoredTagTest < ActiveSupport::TestCase

  test "color code validation" do
    tag = ColoredTag.new(name: 'some tag', :color => '#990000', :text_color => '#788ade')
    assert tag.valid?, "Tag #{tag.inspect} is invalid"
#    assert_invalid Tag.new( @commons.update( :color => '#990000', :text_color => '#788ade'))
  end
end

# == Schema Information
#
# Table name: tags
#
#  id             :integer          not null, primary key
#  name           :string(255)      not null
#  color          :string(7)        default("#FF0000"), not null
#  text_color     :string(7)        default("#FFFFFF"), not null
#  taggings_count :integer          default(0)
#  symbol         :string(255)
#
