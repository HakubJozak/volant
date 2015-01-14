require 'test_helper'

class Export::VefXmlTest < ActiveSupport::TestCase
  setup do
    @form = Factory(:apply_form)
    5.times { @form.add_workcamp Factory(:outgoing_workcamp) }
  end

  test 'to_xml' do
    builder = Export::VefXml.new(@form)
    puts builder.to_xml
  end
end
