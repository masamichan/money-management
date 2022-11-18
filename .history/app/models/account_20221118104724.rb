class Account < ApplicationRecord

  has_and_belongs_to_many :users, :join_table => 'account_users'
  has_many :company_entities, :as => :parent
  has_many :items, :through => :company_entities, :source => :entity, :source_type =>'Item'
  has_many :tasks, :through => :company_entities, :source => :entity, :source_type => 'Task'
  has_many :staffs, :through => :company_entities, :source => :entity, :source_type => 'Staff'
  has_many :clients, :through => :company_entities, :source => :entity, :source_type => 'Client'
  has_many :company_email_templates, :as => :parent
  has_many :email_templates, :through => :company_email_templates, :foreign_key => 'template_id'
  has_many :companies

  before_save :change_currency_symbol

  def change_currency_symbol
    self.currency_symbol = CURRENCY_SYMBOL[:self.currency_code]
  end

  def url 
    self.try(:subdomain).present? ? 
    "#{OSB::CONFIG::APP_PROTOCOL}://#{self.subdomain}.#{OSB::CONFIG::APP_HOST}" : "#{OSB::CONFIG::APP_PROTOCOL}://#{OSB::CONFIG::APP_HOST}"
  end

  def self.url(account_id = nil)
    if account_id.present?
      account = Account.find account_id
      account.url
    else
      "#{OSB::CONFIG::APP_PROTOCOL}://#{OSB::CONFIG::APP_HOST}"
    end
  end

  def self.payment_gateway
    ActiveMerchant::Billing::PaypalGateway.new(
      :login => OSB::CONFIG::PAYPAL[:login],
      :password => OSB::CONFIG::PAYPAL[:password],
      :signature => OSB::CONFIG::PAYPAL[:signature]
    )
  end

end
