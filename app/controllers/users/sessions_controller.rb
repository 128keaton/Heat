class Users::SessionsController < Devise::SessionsController
  # GET /resource/sign_in
  def new
    # Checks for our production environment
    if !ENV["RAILS_ENV"] ||  ENV["RAILS_ENV"] != "production"
      user = User.where(email: "test@me.com")[0]
      if user == nil
        user = User.new(email: 'test@me.com',
                 password: 'ilovepancakes',
                 password_confirmation: 'ilovepancakes',
                 image: ActionController::Base.helpers.asset_path("logo-alt.png"),
                 name: "Test User")
        user.save
      end
      # update our test user to admin
        admin_list = Rails.configuration.api["admins"]
        if admin_list.include? user.email
            user.update_attribute :admin, true
            user.save
        else
           user.update_attribute :admin, false
            user.save
        end
  
      if user_signed_in?
        redirect_to "/"
      else
        if params[:login] && params[:login] == "yes"
          sign_in user
          redirect_to "/"
        else
          redirect_to "/login"
        end
      end
    end
  end
end