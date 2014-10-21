require 'rails/generators/resource_helpers'

class ApiControllerGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  include Rails::Generators::ResourceHelpers

  check_class_collision suffix: "Controller"

  class_option :orm, banner: "NAME", type: :string, required: true,
  desc: "ORM to generate the controller for"

  argument :attributes, type: :array, default: [], banner: "field:type field:type"

  def create_controller_files
    template "controller.rb", File.join('app/controllers', controller_class_path, "#{controller_file_name}_controller.rb")
  end

  hook_for :test_framework, as: :scaffold

end
