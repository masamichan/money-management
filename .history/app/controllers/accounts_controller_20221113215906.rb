class AccountsController < ApplicationController
  # GET /companies
  # GET /companies.json
  def index
    @accounts = current_user.accounts

    respond_to do |format|
      format.html #index.html.erb
      format.json {render json: @accounts}
    end
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
    @account = Account.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @account }
    end
  end

  # GET /companies/new
  # GET /companies/new.json
  def new
    user_company = current_user.accounts
    if user_company.present?
      @account = user_company.first
      redirect_to edit_account_url(@account)
    else
      @account = user_company.build
      respond_to { |format| format.html }
    end
  end

  # GET /companies/1/edit
  def edit 
    @account = Account.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.js
      format.json{ render json: @account }
    end
  end

  # POST /companies
  # POST /companies.json
  def create
    @account = current_user.accounts.build(account_params)

    respond_to do |format|
      
    end
  end







  private

  def account_params
    params.require(:account).permit(:admin_billing_rate_per_hour,
                                    :admin_email,
                                    :admin_first_name,
                                    :admin_last_name,
                                    :admin_password,
                                    :admin_user_name,
                                    :auto_dst_adjustment,
                                    :city,
                                    :country,
                                    :currency_symbol,
                                    :currency_code,
                                    :email,
                                    :fax,
                                    :org_name,
                                    :phone_business,
                                    :phone_mobile,
                                    :postal_or_zip_code,
                                    :profession,
                                    :province_or_state,
                                    :street_address_1,
                                    :street_address_2,
                                    :time_zone)
  end

end
