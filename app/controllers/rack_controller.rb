class RackController < ApplicationController
  def index
    @machine = Machine.new
  end

  def assign
    if Machine.where(serial_number: params[:machine][:serial_number]).length != 0
			existingMachine = Machine.where(serial_number: params[:machine][:serial_number])
			existingMachine.update(client_asset_tag: params[:machine][:client_asset_tag], reviveit_asset_tag: params[:machine][:reviveit_asset_tag], rack: params[:machine][:rack], racked: {"date" => Time.now.strftime("%d/%m/%Y %H:%M")})
			flash[:notice] = "Machine was assigned a rack"
			redirect_to controller: 'rack', action: 'index', type: "success"
		else
			flash[:notice] = "Serial number was not added beforehand"
			redirect_to controller: 'rack', action: 'index', type: "error"
		end
  end
end
