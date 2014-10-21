class MessageMailer < ActionMailer::Base

  def standard_email(msg)
#    attachments['free_book.pdf'] = File.read('path/to/file.pdf')

    mail(to: msg.to,
         from: msg.from,
         body: msg.body,
         subject: msg.subject,
         content_type: "text/html") do |format|
      format.html { render html: msg.body }
    end
  end
end
