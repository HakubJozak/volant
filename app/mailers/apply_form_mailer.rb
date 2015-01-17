class ApplyFormMailer < ActionMailer::Base
  def submitted(apply_form)
    template = EmailTemplate.find_by_action!('submitted')

    mail(to: apply_form.email,
         from: 'no+reply@inexsda.cz',
         subject: msg.subject) do |format|
      format.html { render text: msg.html_body.to_s }
    end    
  end
end
