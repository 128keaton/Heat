class ReceiveController < ApplicationController
  def index
    @machine = Machine.new
    if params[:message]
      @message = params[:message]
      @type = params[:type]
      params.delete :message
      params.delete :type
    end
  end
  def create
     @machine = Machine.new(machine_params)
    if @machine.valid?
       @machine.save
        redirect_to controller: 'receive', action: 'index', message: "Serial has been added.", type: "success"
    else
        redirect_to controller: 'receive', action: 'index', message: "Serial already added", type: "error"
    end

  end

  private

  def machine_params
    params.require(:machine).permit(:serial_number, :role)
  end
end
