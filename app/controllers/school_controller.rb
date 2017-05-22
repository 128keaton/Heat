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
			existing_machine = Machine.where(serial_number: params[:machine][:serial_number])[0]
			
			user_name = @user.name
			current_date = Time.now.strftime("%d/%m/%Y %H:%M")
			location =  params[:school]
			unboxed = {"date" => current_date, "user" => user_name}
			role = existing_machine[:role]

			if params[:machine][:role] && params[:machine][:role] != ""
				role = params[:machine][:role]
			end

			existing_machine.update(location: params[:school], unboxed: unboxed, role: params[:machine][:role])

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