class V1::CardPaymentsController < V1::BaseController
	respond_to :json

	def show
		apply_form = ApplyForm.select(:fee).find_by_slug(params[:id])
		if apply_form
			render json: { fee: apply_form.fee.to_f }
		else
			render json: { message: "No apply form found" }, status: :not_found
		end
	end
end