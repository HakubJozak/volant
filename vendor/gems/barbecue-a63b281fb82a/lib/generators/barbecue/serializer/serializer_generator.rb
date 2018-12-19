require 'rails/generators'
require 'active_model/serializer/generators/serializer/serializer_generator'


class Barbecue::SerializerGenerator < Rails::Generators::SerializerGenerator
  source_root File.expand_path('../templates', __FILE__)
end
