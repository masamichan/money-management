class AuthenticateController < ApplicationController
  skip_before_action :authenticate_user!, only: [:token]

  def token
    user = User.find_by_email params[:email]
    if user.present ? && user.valid_password?(params[:password])
      response = {authentication_token: user.authentication_token, status:200,
                  message: '認証されました'}
    else
      response = {status: 404, message: '認証されませんでした'}
    end

    respond_to do |format|
      format.json {render json: responese}
    end
  end

end
