class StatusController < ApplicationController
  def index
    @roles = Role.all
    @machines = Machine.all
    @schools = School.all
  end
end
