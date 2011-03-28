config.gem "shoulda"
config.gem "factory_girl", :source => "http://gemcutter.org"


config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false

# Disable request forgery protection in test environment
config.action_controller.allow_forgery_protection    = false

# Tell Action Mailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test

ActiveSupport::Deprecation.silenced = true

# TODO - remove fixtures
add_fixtures = Proc.new do |path,extension|
  Dir["#{path}/*.#{extension}"].map do |name|
    File.basename(name, '.' + extension)
  end
end

  files = add_fixtures.call("#{RAILS_ROOT}/db/fixtures/seed","csv")
  files.concat add_fixtures.call("#{RAILS_ROOT}/db/fixtures/seed","yml")
  files.concat add_fixtures.call("#{RAILS_ROOT}/test/fixtures","csv")
  files.concat add_fixtures.call("#{RAILS_ROOT}/test/fixtures","yml")
  ENV["FIXTURES"] = files.uniq.join(',')
