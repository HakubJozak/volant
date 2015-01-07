class SanitizeEmailInterceptor
  def self.delivering_email(message)
    message.to = ['info@inexsda.cz']
    message.subject = "[testing] #{message.subject}"
  end
end

if Rails.env.production?
  ActionMailer::Base.register_interceptor(SanitizeEmailInterceptor)
end
