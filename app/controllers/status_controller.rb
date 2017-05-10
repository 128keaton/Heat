class StatusController < ApplicationController
  before_action :authenticate_user!
  def index
    @roles = Role.all
    @machines = Machine.all
    @schools = School.all
  end
end
