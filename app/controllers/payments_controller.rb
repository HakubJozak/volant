class PaymentsController < ApplicationController
  respond_to :json
  before_action :set_payment, only: [:show, :edit, :update, :destroy]

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

  def create
    @payment = Payment.new(payment_params)
    @payment.save
    respond_with(@payment)
  end

  def update
    @payment.update(payment_params)
    respond_with(@payment)
  end

  def destroy
    @payment.destroy
    respond_with(@payment)
  end

  private

  def set_payment
    @payment = Payment.find(params[:id])
  end

  def payment_params
    params[:payment].permit(:amount, :received, :account)
  end




end
