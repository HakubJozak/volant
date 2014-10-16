require 'test_helper'

class PaginatorTest < ActiveSupport::TestCase

  test 'pagination_bits' do
    scope = OpenStruct.new(current_page: 1, total_pages: 40, limit_value: 10)
    p = Paginator.new(scope)
    assert_equal [1,2,3,4,5,6,'...',40], p.pagination_bits
  end

  test 'pagination bits right' do
    scope = OpenStruct.new(current_page: 1, total_pages: 40, limit_value: 10)
    p = Paginator.new(scope,right: 3)
    assert_equal [1,2,3,4,5,6,'...',37,38,39,40], p.pagination_bits
  end

  test 'pagination bits middle' do
    scope = OpenStruct.new(current_page: 20, total_pages: 40, limit_value: 10)
    p = Paginator.new(scope,left: 2, right: 1)
    assert_equal [1,2,3,'...',15,16,17,18,19,20,21,22,23,24,25,'...',39,40], p.pagination_bits
  end

end
