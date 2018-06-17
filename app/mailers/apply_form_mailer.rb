class ApplyFormMailer < ActionMailer::Base

  def submitted(apply_form)
    data = template_for(apply_form).call(apply_form)

    mail(data.serializable_hash) do |format|
      format.html { render text: data.body }
    end
  end

  private

  def template_for(form)
    code = case form
           when Ltv::ApplyForm then 'ltv/submitted'
           else 'submitted'
           end
    EmailTemplate.find_by_action!(code)
  end


end
