require 'test_helper'
require 'generators/api_controller/api_controller_generator'

class ApiControllerGeneratorTest < Rails::Generators::TestCase
  tests ApiControllerGenerator
  destination Rails.root.join('tmp/generators')
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
