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
    deleted_invoices_payments = Payment.where("payment_method = 'credit AND invoice")
  end

  def 
    
  end
    
end




