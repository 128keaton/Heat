class ReceiveController < ApplicationController
  before_action :authenticate_user!
  def index
    @machine = Machine.new
    @roles = Role.all
  end

  def create
    @machine = Machine.new(machine_params)
    # Checks if the machine is valid
    if @machine.valid?
       # Saves the machine
       @machine.save
        flash[:notice] = "Serial has been added."
        flash[:data] = @machine[:role]
        flash[:type] = "success"
        redirect_to action: 'index'
    else
        flash[:notice] = "Serial already added"
        flash[:data] = @machine[:role]
        flash[:type] = "error"
        redirect_to action: 'index'
    end

  end

  private

  def machine_params
    params.require(:machine).permit(:serial_number, :role)
  end
end
