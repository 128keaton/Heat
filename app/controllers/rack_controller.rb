class RackController < ApplicationController
	before_action :authenticate_user!
  def index
    @machine = Machine.new
    fetch_racks
  end

  def assign
		@user = current_user
		serial_number = params[:machine][:serial_number]
		machine_array = Machine.where(serial_number: serial_number)
    rack = params[:machine][:rack]
    if existing_machine = machine_array[0] 
      if check_if_child_is_sad_and_alone(existing_machine, rack)
      sku = generate_sku(rack, existing_machine[:id])
			existing_machine.update(client_asset_tag: params[:machine][:client_asset_tag], reviveit_asset_tag: params[:machine][:reviveit_asset_tag], rack: sku, racked: {"date" => Time.now.strftime("%d/%m/%Y %H:%M"), "user" => @user.name})
      			set_flash('Machine was assigned a rack')
      else
			set_flash('Serial number has already been racked', 'error')
      end
		else
			set_flash('Serial number has not been logged', 'error')
		end
		redirect_to action: 'index'
  end

  def set_flash(notice, type = 'success')
    flash[:notice] = notice
    flash[:type] = type
  end

  def generate_sku(rack_id, machine_id)
    rack = RackCart.where(rack_id: rack_id)[0]
    children_count = rack[:children].count + 1
    sku = "#{rack_id}-#{children_count}"
    adopt_machine(rack, machine_id)
    sku
  end

  def adopt_machine(rack, machine_id)
    children = rack[:children]
    children.push(machine_id)
    rack.update(children: children)
    if !rack.save!
      set_flash('Serial number has not been logged', 'error')
    end
  end

  def check_if_child_is_sad_and_alone(machine, rack_id)
    rack = RackCart.where(rack_id: rack_id)[0]
    children = rack[:children]
    !children.include? machine[:id]
  end

  def fetch_racks
    @racks = RackCart.all.map do |rack|
      if !rack.full?
        rack
      end
  end
end
end
