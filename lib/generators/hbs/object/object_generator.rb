require 'generators/ember/generator_helpers'
require 'generators/ember/template_generator'

module Hbs
  class ObjectGenerator < Ember::Generators::TemplateGenerator
    source_root File.expand_path('../templates', __FILE__)
    argument :attributes, :type => :array, :default => [], :banner => "field field ..."

    def create_template_files
      file_path = File.join(ember_path, 'templates', class_path, "#{file_name}.hbs")
      template 'object.hbs', file_path

      file_path = File.join(ember_path, 'templates', class_path, "#{file_name.pluralize}.hbs")
      template 'array.hbs', file_path
    end

    def plural
      name.pluralize
    end

    def singular
      name
    end
  end
end
