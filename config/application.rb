require File.expand_path('../boot', __FILE__)

require 'rails/all'
require File.expand_path('../volant', __FILE__)

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module Volant
  class Application < Rails::Application

    config.autoload_paths += %W(#{config.root}/lib)

    config.active_record.timestamped_migrations = false


    # Only load the plugins named here, in the order given. By default, all plugins
    # in vendor/plugins are loaded in alphabetical order.
    # :all can be used as a placeholder for all plugins not explicitly named
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Add additional load paths for your own custom dirs
    # config.load_paths += %W( #{RAILS_ROOT}/extras )
    config.load_paths << "#{RAILS_ROOT}/app/sweepers"


    # Force all environments to use the same logger level
    # (by default production uses :info, the others :debug)
    # config.log_level = :debug

    # Make Time.zone default to the specified zone, and make Active Record store time values
    # in the database in UTC, and return them converted to the specified local zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Comment line to use default local time.
    config.time_zone = 'UTC'

    # The internationalization framework can be changed to have another default locale (standard is :en) or more load paths.
    # All files from config/locales/*.rb,yml are added automatically.
    Dir[File.join(RAILS_ROOT,'config','locales', '{cz,en}', '*.{rb,yml}')].each do |path|
      puts "Loading locale: #{path}"
      config.i18n.load_path << path
    end

    config.i18n.default_locale = :cz

    # Your secret key for verifying cookie session data integrity.
    # If you change this key, all old sessions will become invalid!
    # Make sure the secret is at least 30 characters and all random,
    # no regular words or you'll be exposed to dictionary attacks.
    config.action_controller.session = {
      :session_key => '_volant_session',
      :secret      => Volant::Config::session_secret
    }

    config.action_mailer.default_charset = 'utf-8'

    # Use the database for sessions instead of the cookie-based default,
    # which shouldn't be used to store highly confidential information
    # (create the session table with "rake db:sessions:create")
    config.action_controller.session_store = :active_record_store
  #  CGI::Session::ActiveRecordStore::Session.set_table_name "http_sessions"

    # Use SQL instead of Active Record's schema dumper when creating the test database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    config.active_record.schema_format = :sql

    # Activate observers that should always be running
    # Please note that observers generated using script/generate observer need to have an _observer suffix
    config.active_record.observers = :free_places_observer
  end
end

