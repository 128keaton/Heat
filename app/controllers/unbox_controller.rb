require 'net/http'
require 'csv'

class UnboxController < ApplicationController
  def export
    @location = Location.find(params[:location])
    @machines = Machine.where(location: @location).order(:client_asset_tag)
    @send_csv = CSV.generate(headers: true) do |csv|
      @previous_asset = @machines.first.client_asset_tag.to_i
      csv << ["Qty", "Description", "MCS ID#", "Mfg. Name", "Model No.", "Serial No.", "P.O.#", "Unit Cost", "USB Wireless Card", "Asset Tag Offset"]
      @machines.each do |machine|
        asset_offset = machine.client_asset_tag.to_i - @previous_asset
        csv << ["1", "#{machine.role} Laptop", machine.client_asset_tag, "Dell", "Latitude 3380", machine.serial_number.upcase, " ", " ", "No - Built In", asset_offset.to_s]
        @previous_asset = machine.client_asset_tag.to_i
      end
    end

    respond_to do |format|
      format.csv {send_data @send_csv, filename: "#{@location}-#{Date.today}.csv"}
    end
  end

  def index
    all_locations = Location.all
    @machine = Machine.new
    @role = nil

    verify_locations_exist

    @type = params[:type] if flash[:notice]
    @role = flash[:flash] if flash[:role]

    @location = all_locations.first
    @location = Location.find(flash[:location][:id]) if flash[:location].present?

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
    role_quantity = RoleQuantity.find(params[:machine][:role])
    role = role_quantity.role
    serial_number = parse(params[:machine][:serial_number])
    location = Location.find(params[:location])
    asset_tag = params[:machine][:client_asset_tag]
    can_assign = can_assign(role_quantity)
    return return_to_controller if location.nil?

    if serial_number && can_assign
      machine = Machine.get_machine(serial_number, role)
      set_flash('Location not found', 'error')
      if machine.assign(location, role_quantity, asset_tag)
        print_machine(machine)
      else
        set_flash('Asset tag already assigned to another machine', 'error')
      end
    elsif can_assign
      set_flash('Serial not set. Please try again', 'error')
    else
      set_flash('All computers assigned to role', 'error')
    end

    update_flash_data(location, role.id)
    return_to_controller
  end


  def return_to_controller
    redirect_to action: 'index', school: params[:location]
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
