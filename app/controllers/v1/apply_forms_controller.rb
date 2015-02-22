class V1::ApplyFormsController < V1::BaseController
  respond_to :json

  def create
    attrs = embed_volunteer_attributes(apply_form_params)
    form = apply_forms.create_by_birthnumber(attrs)

    if form.valid? && form.volunteer.valid?
      ApplyFormMailer.submitted(form).deliver
      render nothing: true
    else
      render json: { errors:  form.errors }, status: :unprocessable_entity
    end
  end

  private

  def apply_form_params
    params.require(:apply_form).permit(:gender, :firstname, :lastname, :birthnumber, :nationality, :birthdate,
                                       :birthplace, :occupation, :email, :phone, :fax,
                                       :street, :city, :zipcode,
                                       :contact_street, :contact_city, :contact_zipcode,
                                       :emergency_day, :emergency_night, :emergency_name,
                                       :speak_well, :speak_some, :past_experience,
                                       :motivation, :general_remarks, workcamp_ids: [])



  end

  # HACK: this will be gone when all fields are on ApplyForm
  def embed_volunteer_attributes(original)
    volunteer = {}
    [ :gender, :firstname, :lastname, :birthnumber, :nationality, :birthdate,
      :birthplace, :occupation, :email, :phone, :fax,
      :street, :city, :zipcode,
      :contact_street, :contact_city, :contact_zipcode,
      :emergency_day, :emergency_night, :emergency_name,
      :speak_well, :speak_some, :past_experience ].each do |attr|
      volunteer[attr] = original.delete(attr)
    end

    {
      volunteer_attributes: volunteer,
      motivation: original[:motivation],
      general_remarks: original[:general_remarks],
      workcamp_ids: original[:workcamp_ids]
    }
  end

  def apply_forms
    type = params[:type] || params[:apply_form].try(:[],:type)

    case type.try(:downcase)
    when 'ltv' then Ltv::ApplyForm
    else Outgoing::ApplyForm
    end
  end

end
