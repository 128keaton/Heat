class StatusController < ApplicationController
  before_action :authenticate_user!
  def index
    if !current_user.try(:admin?)
      flash[:notice] = "You need to be an administrator"
      flash[:type] = "error"
       redirect_to "/"
    end
    @roles = Role.all
    @machines = Machine.all
    @schools = School.all
  end
end
