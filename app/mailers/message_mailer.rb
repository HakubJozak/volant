class MessageMailer < ActionMailer::Base

  def standard_email(msg)
#    attachments['free_book.pdf'] = File.read('path/to/file.pdf')

    mail(to: msg.to,
         body: msg.body,
         subject: msg.subject,
         content_type: "text/html")
  end
end
