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

  










































































































end
