class ApplyFormMailer < ActionMailer::Base
  def submitted(apply_form)
    template = EmailTemplate.find_by_action!('submitted')
    data = template.call(apply_form)

    mail(data.serializable_hash) do |format|
      format.html { render text: data.body }
    end    
  end
end
