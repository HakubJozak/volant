class AccountsController < ApplicationController
  respond_to :json

  before_action :find_account, except: [:index,:create]

  def index
    render json: Account.all, each_serializer: AccountSerializer
  end

  # GET /accounts/1
  def show
    render json: @account, serializer: AccountSerializer
  end

  # PATCH/PUT /accounts/1
  def update
    if @account.update(account_params)
      render json: @account, serializer: AccountSerializer
    else
      render_error @account
    end
  end

  private

  def find_account
    @account = Account.current
    # @account = Account.find(params[:id])
  end

  def account_params
    params.require(:account).permit(:season_end, :organization_response_limit, :infosheet_waiting_limit,:organization_id)
  end
end
