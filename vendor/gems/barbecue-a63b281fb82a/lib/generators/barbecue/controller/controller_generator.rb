require 'rails/generators'
require 'rails/generators/rails/scaffold_controller/scaffold_controller_generator'


class Barbecue::ControllerGenerator < Rails::Generators::ScaffoldControllerGenerator
  source_root File.expand_path('../templates', __FILE__)

  remove_hook_for :test_framework

  def create_controller_files
    template "controller.rb", File.join('app/controllers', controller_class_path, "#{controller_file_name}_controller.rb")
    template "test.rb", File.join('test/controllers', controller_class_path, "#{controller_file_name}_controller_test.rb")
  end

  protected

  def serializer_class_name
    "#{class_name}Serializer"
  end

  def model_class_name
    file_name.camelize
  end

end
