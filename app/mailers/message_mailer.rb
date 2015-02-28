class MessageMailer < ActionMailer::Base

  def standard_email(msg)
    msg.attachments.each do |a|
      next unless a.has_data?
      attachments[a.filename] = a.data
    end

    mail(to: msg.to,
         from: msg.from,
         cc: msg.cc,
         bcc: msg.bcc,
         subject: msg.subject) do |format|
      format.html { render text: msg.html_body.to_s }
    end
  end
end
