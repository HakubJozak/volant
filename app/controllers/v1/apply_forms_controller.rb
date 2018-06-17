class V1::ApplyFormsController < V1::BaseController
  respond_to :json

  skip_before_action :verify_authenticity_token

  def create
    attrs = apply_form_params.merge(organization: Account.current.organization,
                                    country: Account.current.organization.country)
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
                                       :emergency_day, :emergency_email, :emergency_name,
                                       :speak_well, :speak_some, :past_experience, :special_needs,
                                       :motivation, :general_remarks, workcamp_ids: [])



  end

  def apply_forms
    type = params[:type] || params[:apply_form].try(:[],:type)

    case type.try(:downcase)
    when 'ltv' then Ltv::ApplyForm
    else Outgoing::ApplyForm
    end
  end

end
