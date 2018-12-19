require 'test_helper'
require 'generators/barbecue/gui/gui_generator'

module Barbecue
  class Barbecue::GuiGeneratorTest < Rails::Generators::TestCase
    tests Barbecue::GuiGenerator
    destination Rails.root.join('tmp/generators')
    setup :prepare_destination

    # test "generator runs without errors" do
    #   assert_nothing_raised do
    #     run_generator ["arguments"]
    #   end
    # end
  end
end
