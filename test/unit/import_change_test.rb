require 'test/test_helper'

class ImportChangeTest < ActiveSupport::TestCase
  context 'ImportChange' do
    setup do
      @wc = Factory(:outgoing_workcamp, :name => 'Old Name')
    end

    should 'generate DIFF on save' do
      change = ImportChange.create(:field => 'name', :value => 'New Name', :workcamp => @wc)
      expected = '<del class="differ">Old</del><ins class="differ">New</ins> Name'
      assert_equal expected, change.diff
    end
  end

end
