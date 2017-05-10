class WelcomeController < ApplicationController
  def login
    notice = nil
    alert = nil
    if user_signed_in?
      redirect_to controller: "root"
      end
  end

  def failure
     notice = nil
    alert = nil
  end
end
