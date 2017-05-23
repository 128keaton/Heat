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

  def all_machine_roles
    machine_by_roles = Hash.new
    Role.all.each do |role|
      machine_by_roles = { name: role[:name], data: Machine.all.where(role: role[:name]).count}
    end
    machine_by_roles
  end
 	def get_quantity_for(location, role)
		@machineArray = Machine.where(location: location, role: role)
		return @machineArray.length
	end
  helper_method :get_quantity_for
  helper_method :all_machine_roles
end
