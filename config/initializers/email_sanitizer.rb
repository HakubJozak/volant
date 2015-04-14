class SanitizeEmailInterceptor
  def self.delivering_email(message)
    message.to = ['info@inexsda.cz','jakub.hozak@gmail.com','workcamp@inexsda.cz']
    message.cc = []
    message.bcc = []
    message.subject = "[testing] #{message.subject}"
  end
end

if Rails.env.staging? or Rails.env.development?
  ActionMailer::Base.register_interceptor(SanitizeEmailInterceptor)
end
