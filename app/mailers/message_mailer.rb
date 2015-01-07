class MessageMailer < ActionMailer::Base

  def standard_email(msg)
    #attachments['lang.csv'] = File.read("#{Rails.root}/db/languages.csv")
    msg.attachments.each do |a|
      attachments[a.file.original_name] = a.file.read
    end

    mail(to: msg.to,
         from: msg.from,
         subject: msg.subject,
         content_type: "text/html") do |format|
      format.html { render text: msg.html_body.to_s }
    end
  end
end
