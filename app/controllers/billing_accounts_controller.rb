class BillingAccountsController < ApplicationController
  before_action :set_billing_account, only: %i[ show edit update destroy ]

  # GET /billing_accounts or /billing_accounts.json
  def index
    @billing_accounts = BillingAccount.all
  end

  # GET /billing_accounts/1 or /billing_accounts/1.json
  def show
  end

  # GET /billing_accounts/new
  def new
    @billing_account = BillingAccount.new
  end

  # GET /billing_accounts/1/edit
  def edit
  end

  # POST /billing_accounts or /billing_accounts.json
  def create
    @billing_account = BillingAccount.new(billing_account_params)

    respond_to do |format|
      if @billing_account.save
        format.html { redirect_to billing_account_url(@billing_account), notice: "Billing account was successfully created." }
        format.json { render :show, status: :created, location: @billing_account }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @billing_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /billing_accounts/1 or /billing_accounts/1.json
  def update
    respond_to do |format|
      if @billing_account.update(billing_account_params)
        format.html { redirect_to billing_account_url(@billing_account), notice: "Billing account was successfully updated." }
        format.json { render :show, status: :ok, location: @billing_account }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @billing_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /billing_accounts/1 or /billing_accounts/1.json
  def destroy
    @billing_account.destroy

    respond_to do |format|
      format.html { redirect_to billing_accounts_url, notice: "Billing account was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_billing_account
      @billing_account = BillingAccount.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def billing_account_params
      params.require(:billing_account).permit(:description, :display_name, :master_billing_account, :name, :open, :baid)
    end
end
