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
    Machine.all.each do |machine|
      key = "#{machine[:role]} Machines"
      if machine_by_roles[key]
        machine_by_roles[key] = machine_by_roles[key].to_f + 1
      else
        machine_by_roles[key] = 1
      end
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
