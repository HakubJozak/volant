source 'https://rubygems.org'


# ruby '2.1.5'

gem 'rails', '4.2.11'
gem 'pg'
gem 'sass-rails', '~> 4.0.3'
gem 'compass-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'nokogiri'
gem 'handlebars'
gem 'pdfkit'
gem 'validates_lengths_from_database'
gem 'dotenv-rails'
gem 'rollbar', '~> 2.7'
gem 'slim-rails'


# Language codes
gem 'iso-639'

gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc


# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

gem 'pry-rails', group: [:development, :test]
gem 'pry-byebug', group: [:development, :test]


gem 'carrierwave'
gem 'differ'
gem 'htmlentities'
gem 'acts-as-taggable-on'
gem 'acts_as_list'

gem 'ember-rails'
gem 'emblem-rails'
gem 'ember-source', '1.7.0'
gem 'ember-data-source', '1.0.0.beta.11'
gem "active_model_serializers", '~> 0.8.2'
gem 'kaminari'
gem 'devise'

gem 'momentjs-rails', '~> 2.8.3'
gem 'modernizr-rails'
gem 'jquery-ui-rails'
gem 'jquery-cookie-rails'
gem 'chart-js-rails'


# All Things Bootstrap
gem 'therubyracer', '0.12.3'
gem 'less-rails'
gem 'twitter-bootstrap-rails', github: 'seyhunak/twitter-bootstrap-rails', branch: 'bootstrap3'

# Bonus
gem 'devise-bootstrap-views'
gem 'bootstrap-generators', '~> 3.2.0'
gem 'barbecue', path: 'vendor/gems/barbecue-a63b281fb82a'
gem 'rack-jsonp-middleware'

gem 'font-awesome-rails'

# only email templates data migration
# gem 'redcarpet', require: false


group :development do
  gem 'letter_opener'
  gem 'ruby-progressbar'
  gem 'faker'
#  gem 'guard-livereload', '2.3.1', require: false
  gem 'mina', '~> 0.3.3', require: false
  gem 'mina-puma', require: false
  gem 'annotate'
end

group :test do
  gem "shoulda"
  gem "factory_girl_rails" #, "~> 1.0"
  gem 'mocha'
end

group :staging, :development do
  gem 'puma', require: false
end
