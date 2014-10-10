class PaymentsController < ApplicationController

  def index
    search = Payment.page(current_page)
    render json: search, each_serializer: PaymentSerializer, meta: { pagination: pagination_info(search) }
  end


end
