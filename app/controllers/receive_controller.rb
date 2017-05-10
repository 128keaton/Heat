class ReceiveController < ApplicationController
  before_action :authenticate_user!
  def index
    @machine = Machine.new
    @roles = Role.all
  end

  def create
     @machine = Machine.new(machine_params)
    if @machine.valid?
       @machine.save
        flash[:notice] = "Serial has been added."
        flash[:data] = @machine[:role]
        flash[:type] = "success"
        redirect_to controller: 'receive', action: 'index', type: "success"
    else
        flash[:notice] = "Serial already added"
        flash[:data] = @machine[:role]
        flash[:type] = "error"
        redirect_to controller: 'receive', action: 'index', type: "error"
    end

  end

  private

  def machine_params
    params.require(:machine).permit(:serial_number, :role)
  end
end
