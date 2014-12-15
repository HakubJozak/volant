class V1::ApplyFormsController < V1::BaseController
  respond_to :json

  def create
    form = Outgoing::ApplyForm.new(apply_form_params)

    if form.save
      render nothing: true
    else
      render json: { errors:  form.errors }, status: :unprocessable_entity
    end
  end

  private

  def apply_form_params
    volunteer = [ :gender, :firstname, :lastname, :birthnumber, :nationality, :birthdate,
                  :birthplace, :occupation, :email, :phone, :fax,
                  :street, :city, :zipcode,
                  :contact_street, :contact_city, :contact_zipcode,
                  :emergency_day, :emergency_night, :emergency_name,
                  :speak_well, :speak_some, :past_experience ]

    params.require(:apply_form).permit({ volunteer_attributes: volunteer }, :motivation, :general_remarks, workcamp_ids: [])
  end

end
