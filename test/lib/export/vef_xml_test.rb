require 'test_helper'


class Export::VefXmlTest < ActiveSupport::TestCase

  test '#to_xml (outgoing)' do
    v = create :volunteer, speak_some: 'french'
    form = create :apply_form,
                  volunteer: v,
                  speak_some: 'spanish, french',
                  speak_well: 'english',
                  occupation: 'student'
    
    2.times { |i| form.add_workcamp(create(:outgoing_workcamp,code: "CODE#{i}")) }

    @result = Export::VefXml.new(form).to_xml

    assert_equal 'STU', xml.css('vef occupation').text
    assert_equal 'CZ', xml.css('vef country').text
    assert_equal 'CODE0', xml.css('vef choice1').text
    assert_equal 'CODE1', xml.css('vef choice2').text
    assert_equal 'english', xml.css('vef language1').text
    assert_equal 'spanish, french', xml.css('vef language2').text
    assert_equal '3', xml.css('vef langlevel1').text
    assert_equal '2', xml.css('vef langlevel2').text
  end

  test '#to_xml (occupation)' do
    export_apply_form occupation: 'OTH'
    assert_css 'vef occupation', 'OTH'

    export_apply_form occupation: 'programmer'
    assert_css 'vef occupation', 'EMP'

    export_apply_form occupation: 'Student in CUNI'
    assert_css 'vef occupation', 'STU'

    export_apply_form occupation: ''
    assert_css 'vef occupation', 'UNE'    
  end

  test '#to_xml (incoming)' do
    form = build :incoming_apply_form, speak_well: 'english'
    @result = Export::VefXml.new(form).to_xml
    assert_equal xml.css('vef language1').text, 'english'
  end

  test '#to_xml (no languages)' do
    form = build :apply_form, speak_some: '', speak_well: ''
    @result = Export::VefXml.new(form).to_xml
    assert_empty xml.css('vef language1')
    assert_empty xml.css('vef language2')    
  end

  private

  def export_apply_form(opts)
    form = build :apply_form, opts
    @result = Export::VefXml.new(form).to_xml    
  end

  def assert_css(css,value)
    assert_equal value, xml.css(css).text
  end
  
  def xml
    assert_not_nil @result
    Nokogiri.parse(@result)
  end

end
