Volant::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb
  config.log_level = :debug

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.action_controller.consider_all_requests_local = true
  config.action_view.debug_rjs                         = true
  config.action_controller.perform_caching             = true

  config.i18n.fallbacks = true

  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true

  ActionMailer::Base.smtp_settings[:address] = "smtp.volny.cz"
  #ActionMailer::Base.smtp_settings[:address] = 'smtp.casblanca.cz'
  #ActionMailer::Base.smtp_settings[:address] = "smtp.etmail.cz"
  # ActionMailer::Base.smtp_settings[:address] = "smtp.upcmail.cz"
  # ActionMailer::Base.smtp_settings[:domain] = "klaipeda"


  ENV['all_mails_to'] = 'jakub.hozak@gmail.com'

  # verbose translate
  module ::I18n
    module Backend
      class Simple
        # alias_method :old_translate, :translate
        # def translate(locale, key, options = {})
        #   puts "Translating '#{key}' with params #{options.inspect}"
        #   old_translate(locale, key, options)
        # end
      end
    end
  end

end
