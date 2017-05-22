class Users::SessionsController < Devise::SessionsController
  # GET /resource/sign_in
  def new
    # Checks for our production environment
    return dev? == false
    user = User.where(email: "test@me.com")[0]
    if user.nil?
      user = create_test_user
      user.save
    end
    # update our test user to admin
    make_god(user)
    handle_redirect
  end

  def handle_redirect
    if user_signed_in?
      redirect_to '/'
    elsif params[:login] && params[:login] == 'yes'
      sign_in user
      redirect_to '/'
    else
      redirect_to '/login'
    end
  end

  def make_god(user)
    user.update_attribute :admin, true
    user.update_attribute :supervisor, true
    user.save
  end

  def dev?
    !ENV['RAILS_ENV'] || ENV['RAILS_ENV'] != 'production'
  end

  def create_test_user
    profile_pic = ActionController::Base.helpers.asset_path('logo-alt.png')
    user = User.new
    user.email = 'test@me.com'
    user.password = 'ilovepancakes'
    user.password_confirmation = 'ilovepancakes'
    user.image = profile_pic
    user.name = 'Test User'
    make_god(user)
    user
  end
end
