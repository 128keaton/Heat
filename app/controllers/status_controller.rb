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
    @machineCount = get_machines_by_date
    
  end

	def csvexport
		@machines = Machine.all
		send_data @machines.to_csv, filename: "status-#{Date.today}.csv"
	end

  def get_machines_by_date
    machineCount = Hash.new()
    Machine.all.each do |machine|
      if machine.imaged
        machineDate = date = Date.parse machine.imaged["date"]
        if machineCount[machineDate]
          machineCount[machineDate] = machineCount[machineDate] + 1
        else
          machineCount[machineDate] = 1
        end
      end
    end
    machineCount = machineCount.sort_by { |date, value| date }.reverse.to_h
    machineCount
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
