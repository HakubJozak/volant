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

  def show
    respond_with(@payment)
  end

  def create
    @payment = if id = params[:payment].delete(:apply_form_id)
                 form = ApplyForm.find(id)
                 form.build_payment(payment_params)
               else
                 Payment.new(payment_params)
               end

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
    params[:payment].permit(:amount, :received, :description, :account, :mean, :returned_date, :returned_amount, :return_reason, :bank_code, :spec_symbol, :var_symbol, :const_symbol)
  end




end
