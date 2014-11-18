require 'generators/ember/generator_helpers'
require 'generators/ember/template_generator'

module Hbs
  class ObjectGenerator < Ember::Generators::TemplateGenerator
    source_root File.expand_path('../templates', __FILE__)
    argument :attributes, :type => :array, :default => [], :banner => "field field ..."

    def create_template_files
      template 'object.hbs', template_path("#{file_name}.hbs")
      template 'array.hbs', template_path("#{file_name.pluralize}.hbs")
      template 'array_route.js.coffee', File.join(ember_path, 'routes', class_path, "#{file_name.pluralize}_route.js.coffee")
      template 'object_route.js.coffee', File.join(ember_path, 'routes', class_path, "#{file_name}_route.js.coffee")
    end

    def plural
      name.pluralize
    end

    def singular
      name
    end

    private

    def template_path(filename)
      File.join(ember_path, 'templates', class_path, filename)
    end
  end
end
