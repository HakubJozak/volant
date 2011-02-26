require 'test_helper'

class LanguagesControllerTest < ActionController::TestCase

  include ActiveScaffoldReadOnlyTester

  protected

  def item
    Language.create(:code => 'xx', :triple_code => 'XXX', :name_en => 'X language')
  end

end
