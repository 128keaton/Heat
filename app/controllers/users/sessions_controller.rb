class Users::SessionsController < Devise::SessionsController
  # GET /resource/sign_in
  def new
    # Checks for our production environment
    if ENV["RAILS_ENV"] && ENV["RAILS_ENV"] == "production"
      redirect_to user_google_oauth2_omniauth_authorize_path
    else  
      user = User.where(email: "test@me.com")[0]
      if user == nil
        user = User.new(email: 'test@me.com',
                 password: 'ilovepancakes',
                 password_confirmation: 'ilovepancakes',
                 image: ActionController::Base.helpers.asset_path("logo-alt.png"),
                 name: "Test User")
        user.save
      end

      if user_signed_in? == false
        sign_in(user)
        redirect_to "/home"
      else
        redirect_to "/home"
      end
    end
  end
end