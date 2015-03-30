require 'test_helper'


class Export::VefXmlTest < ActiveSupport::TestCase

  test 'to_xml' do
    v = Factory(:volunteer,speak_well: 'english',speak_some: 'french')
    @form = Factory(:apply_form, volunteer: v)
    2.times { |i| @form.add_workcamp(Factory(:outgoing_workcamp,code: "CODE#{i}")) }
    xml = Export::VefXml.new(@form).to_xml
 

    assert_not_nil xml
    doc = Nokogiri.parse(xml)

    assert_equal 'CODE0', doc.css('vef choice1').text
    assert_equal 'CODE1', doc.css('vef choice2').text
    assert_equal 'english', doc.css('vef language1').text
    assert_equal 'french', doc.css('vef language2').text    
    assert_equal '3', doc.css('vef langlevel1').text
    assert_equal '2', doc.css('vef langlevel2').text        
  end
end
