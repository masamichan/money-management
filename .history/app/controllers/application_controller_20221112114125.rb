class ApplicationController < ActionController::Base
  include Pundit
  include ApplicationHelper
  include PublicActivity::StoreController
  include PublicActivity::VieiwHelper


  skip_before_action :verify_authenticity_token
  before_action :set_tracstamps_user
  before_action :set_cache_headers
  before_action :set_per_page
  before_action :set_date_format
  before_action :set_current_user
  before_action :set_listing_layout
  before_action :autheticate_user!
  before_action :set_current_company
end
