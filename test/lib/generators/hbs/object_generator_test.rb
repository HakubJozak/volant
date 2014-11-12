require 'test_helper'
require 'generators/hbs/object/object_generator'

class Hbs::ObjectGeneratorTest < Rails::Generators::TestCase
  tests Hbs::ObjectGenerator
  destination Rails.root.join('tmp/generators')
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
