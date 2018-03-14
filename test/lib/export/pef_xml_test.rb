# coding: utf-8
require 'test_helper'


class Export::PefXmlTest < ActiveSupport::TestCase

  setup do
    @org = create(:organization,
                 name: 'Seeds',
                 code: 'SEEDS')
  end


  test '#to_xml' do
    wc = create(:workcamp,
                organization: @org,
                code: 'XWER',
                name: 'Xaverov',
                language: 'English, Russian, Chuvash, Esperanto, French, Italian',
                from: Date.parse('2008-12-15'),
                to: Date.parse('2009-01-3'),
                capacity: 10,
                places: 2,
                tag_list: 'english, french, ger',
                places_for_females: 2,
                places_for_males: 2,
                minimal_age: 18,
                maximal_age: 26,
                train: 'Xaverov',
                area: 'Xaverov u Sázavy',
                accommodation: 'na Paloučku',
                workdesc: 'pití alkoholu ve velkém',
                notes: 'pouze abstinenti',
                description: 'zabijačka a Silvestr.')

    @result = Export::PefXml.new(wc).to_xml

    assert_equal 'XWER', xml.css('projectform project code').text
    assert_equal 'Xaverov', xml.css('projectform project name').text
    assert_equal 'Seeds', xml.css('projectform organization').text
    assert_equal 'SEEDS', xml.css('projectform organization_code').text    

    assert_equal '10', xml.css('projectform project numvol').text
    assert_equal 'STV', xml.css('projectform project project_type').text    
    assert_equal 'eng,rus,chv,epo,fre,ita', xml.css('projectform project languages').text    

    assert_equal 'Xaverov', xml.css('projectform project location').text
    assert_equal 'Xaverov u Sázavy', xml.css('projectform project descr_location_and_leisure').text
  end

  test '#iso_language_codes' do
    export = Export::PefXml.new workcamps(:xaverov)

    str = "English/ German/ Russian/ Georgian."
    assert_equal %w( eng ger rus geo ), export.iso_language_codes(str)

    str = "English and French"
    assert_equal %w( eng fre ), export.iso_language_codes(str)

    str = "English, es"
    assert_equal %w( eng spa ), export.iso_language_codes(str)        

    str = "French/ /Russian/Turkish/Azerbaijani/Georgian"
    assert_equal %w( fre rus tur aze geo ), export.iso_language_codes(str)    
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
