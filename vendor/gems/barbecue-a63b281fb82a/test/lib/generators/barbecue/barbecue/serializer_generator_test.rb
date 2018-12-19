require 'test_helper'
require 'generators/barbecue/serializer/serializer_generator'

module Barbecue
  class Barbecue::SerializerGeneratorTest < Rails::Generators::TestCase
    tests Barbecue::SerializerGenerator
    destination Rails.root.join('tmp/generators')
    setup :prepare_destination

    # test "generator runs without errors" do
    #   assert_nothing_raised do
    #     run_generator ["arguments"]
    #   end
    # end
  end
end
