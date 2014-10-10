class PaymentsController < ApplicationController

  def index
    search = Payment.page(current_page).order('received desc')
    search = search.includes(:apply_form)

    if year = params[:year]
      if year.to_i > 0
        search = search.year(year)
      else
        render status: :bad_request, body: 'Invalid parameters' and return
      end
    end


    render json: search, each_serializer: PaymentSerializer, meta: { pagination: pagination_info(search) }
  end


end
