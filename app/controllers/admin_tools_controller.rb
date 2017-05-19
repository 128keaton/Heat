class AdminToolsController < ApplicationController
  def index
    if !current_user.try(:admin?) ||  !current_user.try(:supervisor?)
      flash[:notice] = "You need to be an administrator or supervisor"
      flash[:type] = "error"
       redirect_to "/"
    end
  end
end
