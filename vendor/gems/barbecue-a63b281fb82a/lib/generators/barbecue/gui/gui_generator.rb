require 'generators/ember/template_generator'

class Barbecue::GuiGenerator < Ember::Generators::TemplateGenerator
  source_root File.expand_path('../templates', __FILE__)

  class_option :templates_type, desc: "Engine for Templates - 'hbs' or 'emblem'", default: 'emblem', aliases: "-t"

  argument :attributes, type: :array, default: [], banner: "field field ..."

  def create_template_files
    sufix = options[:templates_type]

    template "object.#{sufix}", template_path("#{file_name}.#{sufix}")
    template "array.#{sufix}", template_path("#{file_name.pluralize}.#{sufix}")
    template 'array_route.js.coffee', File.join(ember_path, 'routes', class_path, "#{file_name.pluralize}_route.js.coffee")
    template 'object_route.js.coffee', File.join(ember_path, 'routes', class_path, "#{file_name}_route.js.coffee")
    template 'new_route.js.coffee', File.join(ember_path, 'routes', class_path, file_name.pluralize, "#{file_name.pluralize}_new_route.js.coffee")
    #      template 'new_controller.js.coffee', File.join(ember_path, 'controllers', class_path, file_name.pluralize, "#{file_name.pluralize}_new_controller.js.coffee")
    #      template 'object_controller.js.coffee', File.join(ember_path, 'controllers', class_path, "#{file_name}_controller.js.coffee")
    #      template 'array_controller.js.coffee', File.join(ember_path, 'controllers', class_path, "#{file_name.pluralize}_controller.js.coffee")
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
