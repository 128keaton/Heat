class Users::SessionsController < Devise::SessionsController
  # GET /resource/sign_in
  def new
    redirect_to user_google_oauth2_omniauth_authorize_path
  end

end