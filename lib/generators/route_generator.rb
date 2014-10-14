require 'generators/ember/route_generator'

class RouteGenerator < Ember::Generators::RouteGenerator
  source_root File.expand_path("../templates", __FILE__)
end
