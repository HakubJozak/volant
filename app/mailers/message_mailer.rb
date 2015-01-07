class MessageMailer < ActionMailer::Base

  def standard_email(msg)
    msg.attachments.each do |a|
      if a.file
        if filename = a.file_identifier
          attachments[filename] = a.file.read
        end
      end
    end

    mail(to: msg.to,
         from: msg.from,
         subject: msg.subject,
         content_type: "text/html") do |format|
      format.html { render text: msg.html_body.to_s }
    end
  end
end
