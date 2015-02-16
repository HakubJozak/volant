class SanitizeEmailInterceptor
  def self.delivering_email(message)
    message.to = ['info@inexsda.cz','jakub.hozak@gmail.com','workcamp@inexsda.cz']
    message.subject = "[testing] #{message.subject}"
  end
end

if Rails.env.staging?
  ActionMailer::Base.register_interceptor(SanitizeEmailInterceptor)
end
