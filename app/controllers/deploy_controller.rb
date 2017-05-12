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
		end

    @machine = Machine.new
    @schools = School.all
  end

  def get_quantity_for(location, role)
		@machineArray = Machine.where(location: location, role: role)
		return @machineArray.length
	end


	def load_schools
		@school = params[:machine][:location]
		flash[:school] = @school
		redirect_to action: 'index'
	end

  helper_method :get_quantity_for

  def pull
    @machine = params[:machine]
    if Machine.where(rack: @machine[:rack], location: params[:school]).length != 0
			existingMachine = Machine.where(rack: @machine[:rack])
			existingMachine.update(rack: nil, deployed: {"date" => Time.now.strftime("%d/%m/%Y %H:%M")})
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
