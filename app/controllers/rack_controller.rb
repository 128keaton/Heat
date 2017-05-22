class RackController < ApplicationController
	before_action :authenticate_user!
  def index
    @machine = Machine.new
  end

  def assign
		@user = current_user
		serial_number = params[:machine][:serial_number]
		machine_array = Machine.where(serial_number: serial_number)
    if existing_machine = machine_array[0]
			existing_machine.update(client_asset_tag: params[:machine][:client_asset_tag], reviveit_asset_tag: params[:machine][:reviveit_asset_tag], rack: params[:machine][:rack], racked: {"date" => Time.now.strftime("%d/%m/%Y %H:%M"), "user" => @user.name})
			set_flash('Machine was assigned a rack', 'error')
		else
			set_flash('Serial number has not been logged', 'error')
		end
		redirect_to action: 'index'
  end

  def set_flash(notice, type = 'success')
    flash[:notice] = notice
    flash[:type] = type
  end


end
