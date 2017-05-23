class RackController < ApplicationController
	before_action :authenticate_user!
  def index
    @machine = Machine.new
    verify_racks_exist
    fetch_racks
  end

	def verify_racks_exist
		return if RackCart.all.count != 0
		flash[:notice] = "No racks exist"
		flash[:type] = "error"
		redirect_to "/"
	end


  def assign
		@user = current_user
		serial_number = params[:machine][:serial_number]
		machine_array = Machine.where(serial_number: serial_number)

    rack = params[:machine][:rack]
    existing_machine = check_if_machine_exists(machine_array, )
    check_if_child_is_sad_and_alone(existing_machine, rack)
    check_machine_location(rack, existing_machine)
    sku = generate_sku(rack, existing_machine)
    

		existing_machine.update(client_asset_tag: params[:machine][:client_asset_tag], reviveit_asset_tag: params[:machine][:reviveit_asset_tag], rack: sku, racked: {"date" => Time.now.strftime("%d/%m/%Y %H:%M"), "user" => @user.name})
    set_flash("Machine was assigned rack: #{sku}", 'success', 'big')

		#redirect_to action: 'index'
  end

  def check_if_machine_exists(machine_array)
    if existing_machine = machine_array[0] 
      existing_machine
    else
      set_flash('Serial number has not been logged', 'error')
      redirect_to action: 'index'
    end
  end

  def check_machine_location(rack_id, machine)
      rack = RackCart.where(rack_id: rack_id)[0]
      if rack[:location] && rack[:location] != machine[:location]
        set_flash("The machine's location doesn't match the rack's location", 'error')
       redirect_to action: 'index'
      end
  end

  def set_flash(notice, type = 'success', size="")
    flash[:notice] = notice
    flash[:type] = "#{type} #{size}"
  end

  def generate_sku(rack_id, machine)
    rack = RackCart.where(rack_id: rack_id)[0]
    children_count = rack[:children].count + 1
    sku = "#{rack_id}-#{children_count}"
    set_rack_location(rack, machine[:location])
    adopt_machine(rack, machine[:id])
    sku
  end

  def set_rack_location(rack, location)
    if !rack.location
      rack.update(location: location)
      rack.save
    end
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
    if children.include? machine[:id]
      set_flash('Serial number has already been racked', 'error')
      redirect_to action: 'index'
    end
  end

  def fetch_racks
    @racks = RackCart.all.map do |rack|
      if !rack.full?
        rack
      end
    end
  end
end
