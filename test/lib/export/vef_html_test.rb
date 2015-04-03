require 'test_helper'


class Export::VefHtmlTest < ActiveSupport::TestCase

  test '#to_html (outgoing)' do
    v = Factory(:volunteer,speak_some: 'french')
    form = Factory(:apply_form, volunteer: v,
                   firstname: 'Jane',
                   lastname: 'Austen',
                   speak_some: 'spanish, french',
                   speak_well: 'english')
    2.times { |i| form.add_workcamp(Factory(:outgoing_workcamp,code: "CODE#{i}")) }

    @result = Export::VefHtml.new(form).to_html

    assert_equal 'Jane', html.css('td.p-given-name').text
    assert_equal 'Austen', html.css('td.p-family-name').text
    assert_equal 'english', html.css('td.p-speak-well').text
    assert_equal 'spanish, french', html.css('td.p-speak-some').text
  end

  test '#to_html (incoming)' do
    form = Factory(:incoming_apply_form, speak_well: 'english', firstname: 'Tom', lastname: 'Snore')
    @result = Export::VefHtml.new(form).to_html
    assert_equal 'english', html.css('td.p-speak-well').text
    assert_equal 'Tom', html.css('td.p-given-name').text
    assert_equal 'Snore', html.css('td.p-family-name').text
  end

  private

  def html
    assert_not_nil @result
    @doc ||= Nokogiri.parse(@result)
  end

end
