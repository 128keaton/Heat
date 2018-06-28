require 'net/http'
require 'csv'

class UnboxController < ApplicationController
  def index
    all_locations = Location.all
    @machine = Machine.new
    @role = nil

    verify_locations_exist

    @type = params[:type] if flash[:notice]
    @role = params[:role] if params[:role]

    @location = all_locations.first
    @location = Location.find(flash[:location]) if flash[:location].present?

    params[:location] = @location
  end

  def verify_locations_exist
    empty = Location.all.empty?
    set_flash('No locations exist', 'error') if empty
    redirect_to locations_index_path if empty
  end

  def can_assign(role)
    return false if role.max_quantity.zero?
    role.quantity + 1 <= role.max_quantity
  end

  def load_schools
    update_flash_data(params[:machine][:location], nil)
    redirect_to action: 'index'
  end

  def assign
    location = Location.find(params[:location])
    role_quantity = RoleQuantity.find(params[:machine][:role])
    role = role_quantity.role

    update_flash_data(location.id, role_quantity.id)
    set_flash('Unable to find location', 'error')
    return return_to_controller if location.nil?
    set_flash('Unable to find role', 'error')
    return return_to_controller if role.nil?
    serial_number = parse(params[:machine][:serial_number])
    set_flash('Unable to find serial in parameters', 'error')
    return return_to_controller if serial_number.nil?
    asset_tag = params[:machine][:client_asset_tag]
    set_flash('Unable to find asset tag in parameters', 'error')
    return return_to_controller if asset_tag.nil?

    start_assignment(role_quantity, serial_number, role, asset_tag, location)
  end

  def start_assignment(role_quantity, serial_number, role, asset_tag, location)
    can_assign = can_assign(role_quantity)
    if can_assign
      machine = Machine.get_machine(serial_number, role)
      assign_and_print(machine, location, role_quantity, asset_tag)
    else
      set_flash('All computers assigned to role', 'error')
    end

    return_to_controller
  end

  def assign_and_print(machine, location, role_quantity, asset_tag)
    if machine.assign(location, role_quantity, asset_tag)
      print_machine(machine)
    else
      set_flash('Asset tag already assigned to another machine', 'error')
    end
  end


  def return_to_controller
    redirect_to action: 'index', school: params[:location], role: params[:machine][:role]
  end

  def print_machine(machine)
    response = machine.print_label
    Rails.logger.info response
    set_flash(response[:message], response[:status])
  end

  def update_flash_data(location = nil, role = nil)
    flash[:location] = location if location.present?
    flash[:role] = role if role.present?
  end

  def set_flash(notice, type = 'success')
    flash[:notice] = notice
    flash[:type] = type
  end

  private

  def parse(serial)
    if serial.include? ','
      serial = CSV.parse(serial.gsub(/\s+/, ''), col_sep: ',')[0][2]
    end
    serial
  end

  def machine_params
    params.require(:machine).permit(:location, :serial_number)
  end
end
