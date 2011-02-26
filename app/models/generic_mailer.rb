class GenericMailer < ActionMailer::Base


  def plain_email(mail)
    subject    mail.subject
    recipients mail.to
    from       mail.from
    cc        mail.from
    sent_on    Time.now
    body       mail.body

    mail.attachments.each do |a|
      attachment a.content_type do |native_attachment|
        # native_attachment is an instance of ActionMailer::Part
        native_attachment.body = a.generate_data
        native_attachment.filename = a.to_label
      end
    end
  end

end
