class SchoolController < ApplicationController
	def index
		@machine = Machine.new
		@schools = School.all
		@roles = Role.all
		if flash[:notice] 
			@type = params[:type]
		end
		if flash[:school]
			@school = flash[:school]
      params[:school] = @school
		end
	end

	def get_quantity_for(location, role)
		@machineArray = Machine.where(location: location, role: role)
		return @machineArray.length
	end

	def load_schools
		@school = params[:machine][:location]
		flash[:school] = @school
		redirect_to controller: 'school', action: 'index'
	end

	def assign
		if Machine.where(serial_number: params[:machine][:serial_number]).length != 0
			existingMachine = Machine.where(serial_number: params[:machine][:serial_number])
			existingMachine.update(location: params[:school], unboxed: {"date" => Time.now.strftime("%d/%m/%Y %H:%M")})
			flash[:notice] = "Machine was assigned"
			redirect_to controller: 'school', action: 'index', type: "success"
		else
			flash[:notice] = "Serial number was not added beforehand"
			redirect_to controller: 'school', action: 'index', type: "error"
		end
	end

	helper_method :get_quantity_for

	private

	def machine_params
		params.require(:machine).permit(:location, :serial_number)
	end
end