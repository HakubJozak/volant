require 'test_helper'
require 'generators/barbecue/controller/controller_generator'

module Barbecue
  class Barbecue::ControllerGeneratorTest < Rails::Generators::TestCase
    tests Barbecue::ControllerGenerator
    destination Rails.root.join('tmp/generators')
    setup :prepare_destination

    # test "generator runs without errors" do
    #   assert_nothing_raised do
    #     run_generator ["arguments"]
    #   end
    # end
  end
end
