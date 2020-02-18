class V1::CardPaymentsController < V1::BaseController
	respond_to :json
	skip_before_action :verify_authenticity_token

	def create
		if params[:status] == "PAID"
			apply_form = ApplyForm.select(:id).find_by_slug(params[:refId])
			if apply_form
				Payment.create(apply_form_id: apply_form.id, amount: params[:price].to_f / 100, received: DateTime.now.to_date, description: "Platba kartou", mean: "CARD", external_id: params[:transId])
			else
				render json: { message: "No apply form found" }, status: :not_found
			end
		end

		render json: { message: "OK" }, status: :ok
	end

	def show
		apply_form = ApplyForm.select(:fee).find_by_slug(params[:id])
		if apply_form
			render json: { fee: apply_form.fee.to_f }
		else
			render json: { message: "No apply form found" }, status: :not_found
		end
	end
end