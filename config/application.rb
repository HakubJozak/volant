require File.expand_path('../boot', __FILE__)
#require File.join(File.dirname(__FILE__), 'volant')

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Volant
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    config.log_level = :debug

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.time_zone = 'UTC'

    Dir[File.join(Rails.root,'config','locales', '{cz,en}', '*.{rb,yml}')].each do |path|
      # puts "Loading locale: #{path}"
      config.i18n.load_path << path
    end

    config.i18n.default_locale = :en
    config.active_record.schema_format = :sql

    # Deprecated options?
    # config.action_mailer.default_charset = 'utf-8'
    # config.active_record.observers = :free_places_observer
    require 'rack/jsonp'
    config.middleware.use Rack::JSONP

    config.generators do |g|
      g.orm             :active_record
      g.template_engine false # :erb
      g.helper false
      g.test_framework  :test_unit, fixture: false
      g.stylesheets     false
      g.javascripts     false
    end
  end
end
