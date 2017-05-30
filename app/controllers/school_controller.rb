class SchoolController < ApplicationController
	before_action :authenticate_user!
	def index
		@machine = Machine.new
		@schools = School.all
		@roles = Role.all
		verify_schools_exist
		if flash[:notice]
			@type = params[:type]
		end
		if flash[:school]
			@school = flash[:school]
			params[:school] = @school
		end
	end

	def verify_schools_exist
		return if @schools.count != 0
		flash[:notice] = "No schools exist"
		flash[:type] = "error"
		redirect_to "/"
	end

	def get_quantity_for(location, role)
		@machineArray = Machine.where(location: location, role: role)
		return @machineArray.length
	end

	def automatic_assignment(location)
		if get_quantity_for(location, "Teacher") < School.where(name: location)[0].quantity["Teacher"]
			return "Teacher"
		elsif get_quantity_for(location, "Student") < School.where(name: location)[0].quantity["Student"]
			return "Student"
		end
	end

	def load_schools
		@school = params[:machine][:location]
		flash[:school] = @school
		redirect_to controller: 'school', action: 'index'
	end

	def build_reply(machine, school)
		current_date =  Time.now.strftime("%d/%m/%Y %H:%M")

		unboxed = {"date" => current_date, "user" => current_user.name}

		role = machine[:role]
		passed_role = params[:machine][:role]


		if passed_role && passed_role != ""
			role = passed_role
		end

		machine.update(location: params[:school],  unboxed: unboxed, role: role)
	end

	def assign
		serial_number = params[:machine][:serial_number]
		machine_array = Machine.where(serial_number: serial_number)

		if machine_array.length != 0
			existing_machine = machine_array[0]
			build_reply(existing_machine)

			set_flash("Machine was assigned", "success")
			redirect_to action: 'index'
		else
			#set_flash("Serial number has not been logged", "error")
			#redirect_to action: 'index'
			current_date =  Time.now.strftime("%d/%m/%Y %H:%M")

			unboxed = {"date" => current_date, "user" => current_user.name}

			role = automatic_assignment(params[:school])
			passed_role = params[:machine][:role]


			if passed_role && passed_role != ""
				role = passed_role
			end

			Machine.create(serial_number: serial_number, location: params[:school],  unboxed: unboxed, role: role)
			redirect_to action: 'index'
		end
	end

	def set_flash(notice, type)
		school = params[:school]
		existing_role = params[:machine][:role]

		flash[:notice] = notice
		flash[:school] = school
		flash[:type] = type
		flash[:data] = existing_role
	end

	helper_method :get_quantity_for

	private

	def machine_params
		params.require(:machine).permit(:location, :serial_number)
	end
end
