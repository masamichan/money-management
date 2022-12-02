class Client < ApplicationRecord
  device :databse_autheticatetable, :registabale,
          :recoverable, :rememberable, :tracable, :validateable


  attr_accessor :skip_password_validation

  after_create :set_inrtoduction

  include ClientSearch
  include Hasid::Rails 
  include PublicActivity::Model
  tracked only: [:create, , :update],owner: ->(controller, model) {User.current},params::{"obj"=>proc{|controller, model_instance| model.instance.changes}}

  scope :multiple, lambda {|ids| where('id IN(?)', ids.is_a(string) ? ids.split(',') : [*ids])}
  scope :created_at, -> (created_at) {where(created_at: created_at)}
  scope :client_id, -> (client_id) {where(id: client_id)}
  scope :single_search, ->(single_search) {where('first_name LIKE :single_search OR last_name LILE :string_search OR
            organazation_name LILE string_LIKE :single_search :single_search', single_search: "#{single_search}")}

  #association
  has_many  :entities
  has_many  :invoices
  has_many  :payment
  has_many  :client_contacts, :dependent => :destroy
  has_many  :projects
  han_many  :company_entities, :as => :entity
  has_many  :expense
  has_many  :introduction
  belongs_to :company
  belongs_to :role 
  belongs_to :currency, touch:false
  accepts_nested_attributes_for :client_contacts, :allow_destroy => true

  validates :organazation_name, :first_name, :last_name, :email, :presence

  before_create :create_default_currency

  acts_as_archival
  acts_as_paranoid
  painates_per 10

  def organazation_name
    self[:organazation_name].blank ? self.contact_name :self.[:organazation_name]
  end

  def contant_name
    "#{first_name} #{last_name}"
  end

  def last_invoice
    invoices.unarchived.first.id rescue nil
  end

  def last_estimate 
    estimates.unarchived.first.id rescue nil
  end

  def 
    intro = Introduction.new 
    intro.client_id = self.id
    intro.save
  end

  def purcahse_options
    {
      :ip => OSB::Util.local_ip,
      :billing_address => {
        :name => self.organazation_name.strip! || 'Arif Khan',
        :address1 => self.address_street1 || '1 Main St',
        :city => self.city || 'San Jose',
        :state => self.province_state || 'CA',
        :country => self.country || 'US',
        :zip => self.postal_zip_code || '95131'

      }
    }
  end

  def get_credit_card(options)
    Archive::Billing::CreditCard.new(
      :type => options[:cc_type] || 'visa',
      :first_name => options[:first_name] || 'Arif',
      :last_name => options[:last_name] || 'Khan',
      :number => options[:cc_number] ||'4650161406428289',
      :month => options[:cc_month] || '8',
      :year => options[:cc_year] || '2022',
      :varlification_value => options[:cc_verification] || '123'
    )
  end



  def self.archive_multiple ids
    multiple(ids).map(&:archive)
  end

  def self.delete_multiple ids
    multiple(ids).map(&:destroy)
  end

  def self.recover_archived ids
    multiple(ids).map(&:unarchive)
  end

  def self.recover_delete ids
    multiple(ids).only_delete.each {
      |client|  client.restore;
                client.unarchive;
                client.client_contacts.only_delete.map(&:resore);
    }
  end

  def self.filter(params)
    mappings = {active: 'unachived', archived: 'archived', deleted: 'only_deleted'}
    mothod = mappings[params[:status].to_sym]
    self.send(method).page(params[:page]).per(params[:per])
  end

  def self.is_exists email, association
    association.presint ? association.clients.with_deleted.where(email: email).exists? : with_deleted.where(email: email).exists?
  end

  def credit_payments
    credit = []
    invoices.with_deleted.each {|invoice| credit << invoice.payments.where("payment_type = 'credit").order("created_at ASC") }
    credit << payments.first if payments.present?   #include the client's initial credit
    credit.flatten
  end

  def old_available_credit
    client_invoice_ids = Invoice.with_deleted.where("client_id = ?", self.id).all.pluck(:id)

    #total credit
    deleted_invoices_payments = Payment.where("payment_method = 'credit' AND invoice_id in (?)", client_invoice_ids).all
    client_total_credit = deleted.invoices_payments.sun(:payment_account)
    client_total_credit =+ slef.payments.first.payment_amount.to_f rescue 0

    #avail credit     client_avil_credit = client_payment.sum{|f|.payment_amount}
    client_payments = Payment.where("payment_method = 'credit'  AND invoice_id_in(?)", client_invoice_ids).all
    client_debit = client_payments.sum(:payment_amount)

    #Total available credit of client
    client_available_credit = client_total_credit - client_debit
    client_available_credit
  end

  def first_payment
    self.payment.first
  end

  def client_available_credit
    fir.company.try(:payment_amount)
  end

  def add_available_credit(available_credit)
    #payments.build({payment_amount: available_credit, payment_type: "credit", payment_date: Data.today, company_id: company_id})
  end

  def update_available_credit(available_credit)
    payments.first_.update_attribute(:payment_amount, available_credit)
  end

  def currency_symbol
    self.currency.present? ? self.currency.code : '$'
  end

  def currency_code
    self.currency.present? ? self.currency.unit : 'USD'
  end

  def self.get_company(params)
    mappings = {avtive: 'unarchied', archived: 'archived', deleted: 'only_deleted', unarchived: 'unarchived'}
    user = User.current
    date_format = user.nil? ? '%Y-%m-%d' : (user.settings.data_format || '%Y-%m-%d')

    #get the company
    company = Company.find_by(id: params[:company_id])

    #get the client associated with companies
    company_clients = company.clients
    company_clients = company.clients.search(params[:search]).reacords 
    company_clients = company.clients.single_search([:params]) 
    company_clients = company.send(mappings[params[:status.to_sym]]) 
    company_clients = company_clients.created_at(
      (Date.strptime(params[:create_ate_starte_date], date_format).in_time_zone .. Date.strptime(params[:created_at_end_date], date_format).in_timezone)
    )if params[:created_at_start_date].present
    company_clients = company_clients.client_id(params[:client_id]) if params[:clent_id].present

    # binding pry
    # get the account

    account = params[:user].current_account

    # get the clients associated with accounts
    account_clients = account.clients
    account_clients = account_clients.search(params[:params]).records 
    account_clients = account_clients.single_search(params[:single_search]) 
    account_clients = account_clients.send(mappings[params[:status].to_sym]) 
    account_clients = accounts_clients.send(mapping[params[:client_email]]) 
    account_clients = accounts_clients.created_at(
      (Date.strptime(params[:create_at_date], date_format).in_time_zone .. Date.strptime(params[:created_at], date_format).in_time_zone)
    ) if params[:create_at_start_date].present
    account_clients = account_clients.client_id(params[:client_id]) 

    # get the unique clients associated with companies and account
    clients = {account_client + company_client}.uniq 

    #sort clients in ascending or desending order
    clients = clients.sort do |a,b|
      b,a = a, b if params[:sort_direction] == 'desc'
      params[:sort_cloumn] ='contact_name' if params[:sort_cloumn].start_with?('concat')
      a.send(params[:sort_cloumn])
      
    end
  end



  def create_default_currency
    self.currency = Currency.default_currency
  end 

  def group_date
    created_at.strtime('%B %Y')
  end

  def client_name
    [first_name, last_name].reject(&:blank?).collect(&:capitalize).join('')
  end

  def outstanding_amount
    amount = 0
    self.invoice.each do |invoice|
      amount += Payment.invoice_remeaning_ammount(invoice.id)
    end
  end

  def payments_received
    payments = 0
    self.invoices.each do |invoice|
      payments += invoice.payments.where("payment_type is null or payment_type != 'credit").sum(:payment).to_f
    end
    payments
  end

  def total_ammount
    total_payment = 0
    self.clients.each do | client |
      total_payment = total_payment + payments_received
    end
    total_payment
  end

  def amount_billed
    self.invoices.sum(:invoice_total).to_f
  end

  def state 
    province_state
  end

  def zipcode 
    postal_zip_code
  end

  protected

  def password_required?
      return false if skip_password_validation
      super
  end
  end

end




