require 'test_helper'


class Export::VefXmlTest < ActiveSupport::TestCase

  test '#to_xml (outgoing)' do
    v = Factory(:volunteer,speak_some: 'french')
    form = Factory(:apply_form, volunteer: v, speak_some: 'spanish, french',speak_well: 'english')
    2.times { |i| form.add_workcamp(Factory(:outgoing_workcamp,code: "CODE#{i}")) }

    @result = Export::VefXml.new(form).to_xml

    assert_equal 'CODE0', xml.css('vef choice1').text
    assert_equal 'CODE1', xml.css('vef choice2').text
    assert_equal 'english', xml.css('vef language1').text
    assert_equal 'spanish, french', xml.css('vef language2').text
    assert_equal '3', xml.css('vef langlevel1').text
    assert_equal '2', xml.css('vef langlevel2').text
  end

  test '#to_xml (incoming)' do
    form = Factory(:incoming_apply_form, speak_well: 'english')
    @result = Export::VefXml.new(form).to_xml
    assert_equal xml.css('vef language1').text, 'english'
  end

  private
  
  def xml
    assert_not_nil @result
    @doc ||= Nokogiri.parse(@result)    
  end

end
