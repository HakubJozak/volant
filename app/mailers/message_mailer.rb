class MessageMailer < ActionMailer::Base
  default content_type: 'text/html', charset: 'UTF-8'

  def standard_email(msg)
    msg.attachments.each do |a|
      next unless a.has_data?

      attachments[a.filename] = {
        content: Base64.encode64(a.data),
        transfer_encoding: :base64,
        mime_type: a.mime_type
      }
    end

    @body = msg.html_body.to_s.force_encoding('UTF-8')

    mail(to: msg.to,
         from: msg.from,
         cc: msg.cc,
         bcc: msg.bcc,
         subject: msg.subject) do |format|
      format.html
    end
  end
end
