class Internal::AccountsController < Internal::BaseController
  include MinimalResponders

  before_action :find_account

  def index
    render action: "edit"
  end

  def edit

  end

  # PATCH/PUT /accounts/1
  def update
    @account.update(account_params)
    respond_with @account, location: index_path
  end

  private

  def find_account
    @account = Account.current
    # @account = Account.find(params[:id])
  end

  def index_path
    internal_accounts_path
  end

  def account_params
    params.require(:account).permit(:season_end, :organization_response_limit, :infosheet_waiting_limit,:organization_id)
  end
end
