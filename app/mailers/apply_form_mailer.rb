class ApplyFormMailer < ActionMailer::Base

  def emergency_confirmation(application)
    send_custom_template application, 'emergency_confirmation'
  end

  def submitted(application)
    vef = Export::VefPdf.new(application)
    
    attachments[vef.filename] = {
      content: Base64.encode64(vef.to_pdf),
      transfer_encoding: :base64,
      mime_type: 'application/pdf'
    }
    
    send_custom_template application, 'submitted'
  end

  private

  def send_custom_template(application, action)
    data = template_for(application, action).call(application)

    mail(data.serializable_hash) do |format|
      format.html { render text: data.body }
    end
  end

  def template_for(application, name)
    code = if application.is_a? Ltv::ApplyForm
             "ltv/#{name}"
           else
             name
           end
    
    EmailTemplate.find_by_action!(code)
  end


end
