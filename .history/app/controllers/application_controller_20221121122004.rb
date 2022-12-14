class ApplicationController < ActionController::Base
  include Pundit
  include ApplicationHelper
  include PublicActivity::StoreController
  include PublicActivity::ViewHelpers


  skip_before_action :verify_authenticity_token
  before_action :set_trackstamps_user
  before_action :set_cache_headers
  before_action :set_per_page
  before_action :set_date_format
  before_action :set_current_user
  before_action :set_listing_layout
  before_action :authenticate_user!
  before_action :set_current_company
  before_action :set_locale
  before_action :_reload_libs
  before_action :configure_permitted_parameters, if: :devise_controller?

  acts_as_token_authentication_handler_for User, if: lambda { |env| env.request.format.json? && controller_name != 'authenticate' }

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  layout Proc.new {'login' if diveise_controller? }

  helper_method :filter_by_company, :render_card_view?

  def _reload_libs
    if defined? RELOAD_LIBS
      RELOAD_LIBS.each do |lib|
      end
    end
  end

  def user_introduction
    current_user.introduction.update_attribute(get_introduction_parameter, true)
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(User) && OSB::CONFIG::DEMO_MODE
      resource.reset_default_settings
      session[:view] = 'table'
      params[:locale] = 'en'
      dashboard_path(params[:locale])
    elsif resource.is_a?(User)
      dashboard_path(params[:locale])
    else
      portal_dashboard_index_path(locale: :en)
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    if resource_or_scope == :user 
      new_user_session_path(locale: :en)
    else
      new_portal_client_session_path(locale: :en)
    end
  end

  def encryptor
    secret = Digest::SHA1.hexdigest("yourpass")
    ActiveSupport::MessageEncryptor.new(secret)
  end

  def encrypt(message)
    e = encryptor
    e.encrypt(message)
  end

  def decrypt(message)
    e = encryptor
    e.decrypt(message)
  end

  def choose_layout
    %w(preview payments_history).include?(action_name) ? 'preview_mode' : 'application'
  end

  def associate_entity(params, entity)
    ids, controller = params[:company_ids], params[:controller]

    ActiveRecord::Base.transaction do
      if action_name == 'update'
        entities = controller == 'email_templates' ? CompanyEmailTemplate.where(template_id: entity.id) : CompanyEntity.where(entity_id: entity.id, entity_type: entity.class.to_s)
        entities.map(&:destroy) if entities.present?
      end

      Company.multiple(ids).each{|campany| company.send(controller) << entity } unless ids.blank?
    end
  end

  def set_current_company(elem, tbl=params[:controller])
    unless params[:company_id].blank?
      session['current_company'] = params[:company_id]
    end

    elem.where("#{tbl}.company_id IN(?)", get_company_id())
  end

  def new_selected_company_name
    session['current_company'] = params[:company_id]
    current_user.update_attributes(current_company: params[:company_id])
    company = Company.find(params[:company_id])
    render :text => company.company_name
  end

  
  def get_company_id
    current_user.current_company || session['current_company'] || current_user.first_company_id
  end

  def get_clients_and_items
    parent = Company.find(params[:company_id] || get_company_id)
    @get_clients = get_clients(parent)
    @get_items = get_items(parent)
    @parent_class = parent.class.to_s
  end

  def get_clients(parent)
    options = ''
    parent.clients.each {|client| options += "<option value=#{client.id} type='company_level'>#{client.organazation_name}</option>" } if present.clients.present?
  end

  def get_items(parent)
    options = ''
    parent.items.each { |item| options += "<option value=#{item.id} type='company_level>#{item.item_name}</option>" } if parent.items.present?
  end

  def set_date_format
    gon.dataformat = get_data_format
  end

  def set_per_page
    @per_page = if params[:per]
      params[:per]
    else
      if current_user.present?
        current_user.records_per_page
      else
        session["#{controller_name}-per_page"]
      end
    end
  end

  def set_current_user
    User.current = current_user
  end

  def set_listing_layout 
    if params[:view].nil? && current_user
      session[:view] ||= current_user.index_page_format || 'card'
    else
      session[:view] = params[:view]
    end
  end

  def render_json(obj)
    if obj.errors.present?
      render json: {erros: obj.errors.full_messages.join('.')}, status: :unprocessable_entity
    else
      render_json: {}
    end
  end

  def render_card_view?
    params[:view] ||= session[:view]
    params[:view] == 'card'
  end

  def get_associatoin_obj
    params[:association] == 'account' ? current_account : Company.find(get_company_id)
  end

  protected

  def configure_permitted_parameters
    device_parameter_sanitizer.permit(:sign_up) {|u| u.permit(:user_name, :account, :email, :password, :password_confirmation, :remember_me)}
    device_parameter_sanitizer.permit(:sign_in) {|u| u.permit(:login, :user_name, :account, :email, :password, :remember_me)}
    device_parameter_sanitizer.permit(:account) {|u| u.permit(:user_name, :account, :email, :password, :password_confirmation, :current_password)}
  end

  def set_locale
    I18n.locale = current_user.settings.language.try(:to_sym) || params[:locale] || I18n.default_locale if current_user
  end

  def default_url_options(options = {})
    {local: I18n.locale}.merge options
  end

  private

  def user_not_authorized
    flash[:alert] = "?????????????????????????????????????????????????????????"
    if request.format.js
      render js: "window.location = '#{request.refferer || root_path}'"
    else
      redirect_to(request.refferer || dashboard_path)
    end
  end

  def user_not_authorized
    response.headers["Cache-Control"] = "no-cache, no-store"
    response.headers["Pragma"] = "no-chace"
    response.headers["Expires"] = "Mon, 01 Jan 1990 00:00:00 GTM"
  end
end
