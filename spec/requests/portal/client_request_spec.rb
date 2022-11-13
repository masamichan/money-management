require 'rails_helper'

RSpec.describe "Portal::Clients", type: :request do

  describe "GET /settings" do
    it "returns http success" do
      get "/portal/client/settings"
      expect(response).to have_http_status(:success)
    end
  end

end
