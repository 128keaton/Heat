class RootController < ApplicationController
  before_action :authenticate_user!
  def index
    if !current_user.nil? && user_signed_in?
      @user = current_user
    else
      puts "butt"
      redirect_to "/login"
    end
  end
end
