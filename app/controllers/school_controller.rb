class SchoolController < ApplicationController
 	before_action :authenticate_user!
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
		@user = current_user
		if Machine.where(serial_number: params[:machine][:serial_number]).length != 0
			existingMachine = Machine.where(serial_number: params[:machine][:serial_number])
			existingMachine.update(location: params[:school], unboxed:  {"date" => Time.now.strftime("%d/%m/%Y %H:%M"), "user" => @user.name})
			flash[:notice] = "Machine was assigned"
			flash[:school] = params[:school]
			flash[:type] = "success"
			redirect_to action: 'index'
		else
			flash[:notice] = "Serial number has not been logged"
			flash[:school] = params[:school]
			flash[:type] = "error"
			redirect_to action: 'index'
		end
	end

	helper_method :get_quantity_for

	private

	def machine_params
		params.require(:machine).permit(:location, :serial_number)
	end
end