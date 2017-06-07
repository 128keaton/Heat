# Encoding: utf-8

# Some documentation about DeployController

class DeployController < ApplicationController
	before_action :authenticate_user!
	def index
		
		@roles = Role.all
		if flash[:notice]
			@type = params[:type]
		end
		if flash[:school]
			@school = flash[:school]
			params[:school] = @school
			fetch_racks(@school)
		end

		@machine = Machine.new
		@schools = School.all

	end

	def fetch_racks(school)
	  @racks = []
	  RackCart.all.each do |rack|
		if rack.location == school && (rack.full == false || rack.full == nil) && rack != nil
			@racks.push(rack)
		end
	  end

	  if @racks.count == 0
			flash[:notice] = "No racks found"
			flash[:type] = "error"
			flash[:school] = params[:school]
	  end 
	end


	def get_quantity_for(location, role)
		@machineArray = Machine.where(location: location, role: role)
		return @machineArray.length
	end

	helper_method :get_quantity_for

	def get_rack_range(location, role)
		rack_array = []
		Machine.where(location: location, role: role).each do |machine|
			rack_array << machine[:rack]
		end
		return "#{rack_array.first} - #{rack_array.last}"
	end
	helper_method :get_rack_range

	def load_schools
		@school = params[:machine][:location]
		flash[:school] = @school
		redirect_to action: 'index'
	end


	def pull
		@machine = params[:machine]
		if Machine.where(rack: @machine[:rack], location: params[:school]).length != 0
			existingMachine = Machine.where(rack: @machine[:rack])
			existingMachine.update(rack: nil, deployed: {"date" => Time.now.strftime("%d/%m/%Y %H:%M"), "user" => current_user.name})
			flash[:notice] = "Machine was added to deployment list"
			flash[:type] = "success"
			flash[:school] = params[:school]
			redirect_to action: 'index'
		else
			flash[:notice] = "Machine doesn't exist in rack"
			flash[:type] = "error"
			flash[:school] = params[:school]
			redirect_to action: 'index'
		end
	end
end