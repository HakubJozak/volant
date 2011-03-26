# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
# config.cache_classes = true

# Rails 2.2 bug 802 hot fix
config.cache_classes = (File.basename($0) == "rake" && ARGV.include?("db:migrate")) ? false : true


# Enable threaded mode
# config.threadsafe!

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"


# config.action_mailer.delivery_method = :smtp
# config.action_mailer.server_settings = {
#   :address => '',
#   :port => '',
#   :domain => '',
#   :authentication => :login,
#   :user_name => '',
#   :password => ''
# }

config.action_mailer.raise_delivery_errors = true
config.action_mailer.delivery_method = :smtp
config.action_mailer.perform_deliveries = true

ActionMailer::Base.smtp_settings[:address] = "sumec.onesim.net"
ActionMailer::Base.smtp_settings[:domain] = "bolen.onesim.net"


#ENV['all_mails_to'] = 'info@inexsda.cz'
# config.i18n.default_locale = :en if RAILS_ROOT =~ /.*volant\/demo.*/
