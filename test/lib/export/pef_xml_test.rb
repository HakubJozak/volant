require 'test_helper'


class Export::PefXmlTest < ActiveSupport::TestCase

  test '#to_xml' do
    wc = workcamps(:xaverov)
    @result = Export::PefXml.new(wc).to_xml
    assert_equal 'XWER', xml.css('projectform project code').text
    assert_equal '10', xml.css('projectform project numvol').text    
  end

  test '#filename' do
    wc = workcamps(:xaverov)
    assert_match /PEF_XWER_\d{8}.xml/, Export::PefXml.new(wc).filename
  end
  
  private

  def assert_css(css,value)
    assert_equal value, xml.css(css).text
  end

  def xml
    assert_not_nil @result
    @xml ||= Nokogiri.parse(@result)
  end

end
