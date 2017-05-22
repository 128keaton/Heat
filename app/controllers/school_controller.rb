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

	def build_reply(machine) 
		user_name = current_user.name
		location =  params[:school]
		unboxed = {"date" => Time.now.strftime("%d/%m/%Y %H:%M"), "user" => user_name}
		role = existing_machine[:role]
		passed_role = params[:machine][:role]

		if passed_role && passed_role != ""
			role = passed_role
		end

		machine.update(location: location,  unboxed: unboxed, role: role)
	end
	def assign
		serial_number = params[:machine][:serial_number]
		machine_array = Machine.where(serial_number: serial_number)
		if machine_array.length != 0
			existing_machine = machine_array[0]
			build_reply(existing_machine)
			flash[:notice] = "Machine was assigned"
			flash[:school] = params[:school]
			flash[:type] = "success"
			flash[:data] = params[:machine][:role]
			redirect_to action: 'index'
		else
			flash[:notice] = "Serial number has not been logged"
			flash[:school] = params[:school]
			flash[:type] = "error"
			flash[:data] = params[:machine][:role]
			redirect_to action: 'index'
		end
	end

	helper_method :get_quantity_for

	private

	def machine_params
		params.require(:machine).permit(:location, :serial_number)
	end
end