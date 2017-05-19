class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.email.split("@").last == "er2.com"
        supervisor_list = Rails.configuration.api["supervisors"]
        admin_list = Rails.configuration.api["admins"]

        if admin_list.include? @user.email
            @user.update_attribute :admin, true
            @user.update_attribute :supervisor, true
            @user.save
        elsif supervisor_list.include? @user.email
            @user.update_attribute :supervisor, true
            @user.save
        else
            @user.update_attribute :admin, false
            @user.update_attribute :supervisor, false
            @user.save
        end
        
        if @user.persisted?
            sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
            set_flash_message(:notice, :success, :kind => "Google OAuth") if is_navigational_format?
        else
            session["devise.google_oauth2_data"] = request.env["omniauth.auth"]
            redirect_to new_user_registration_url
        end
    else
        redirect_to controller: "/welcome", action: "failure"
    end
  end

  def failure
    redirect_to root_path
  end
end