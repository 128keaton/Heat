require 'net/http'

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
		elsif params[:school]
			@school = params[:school]
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
		if get_quantity_for(location, "Teacher") < School.where(name: location)[0].quantity["Teacher"].to_i
			return "Teacher"
		elsif get_quantity_for(location, "Student") < School.where(name: location)[0].quantity["Student"].to_i
			return "Student"
		else
			return "Full"
		end

	end

	def load_schools
		@school = params[:machine][:location]
		flash[:school] = @school
		redirect_to controller: 'school', action: 'index'
	end

	def build_reply(machine)
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
		assignment = automatic_assignment(params[:school])

		if machine_array.length != 0
			existing_machine = machine_array[0]
			build_reply(existing_machine)

			set_flash("Machine was assigned", "success")
			redirect_to action: 'index'
		elsif assignment != "Full"
			#set_flash("Serial number has not been logged", "error")
			#redirect_to action: 'index'
			current_date =  Time.now.strftime("%d/%m/%Y %H:%M")

			unboxed = {"date" => current_date, "user" => current_user.name}

			role = assignment
			passed_role = params[:machine][:role]


			if passed_role && passed_role != ""
				role = passed_role
			end

			Machine.create(serial_number: serial_number, location: params[:school],  unboxed: unboxed, role: role, client_asset_tag: params[:machine][:client_asset_tag])
			#Definitions for labels
			if School.where(name: params[:school]).first.blended_learning?
				@image_string = "Blended Learning Device"
			else
				@image_string = "Standard Device"
			end
			
			@school_string = params[:school]

			@asset_tag = params[:machine][:client_asset_tag]

			@serial_number = serial_number

			@model = "Dell 3380"

			@type = Role.where(name: role).first.suffix

			uri = URI.parse("#{ENV["LABEL_PRINT_SERVER"]}?image=#{@image_string}&asset_number=#{@asset_tag}&serial_number=#{@serial_number.upcase}&school=#{@school_string}&model=#{@model}&type=#{@type}")
			begin 
				response = Net::HTTP.get_response(uri)
			rescue Net::OpenTimeout
				retry
			end
			redirect_to action: 'index', school: params[:school]
		else
			set_flash("School has been assigned all units!", "error")
			redirect_to action: 'index', school: params[:school]	
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
