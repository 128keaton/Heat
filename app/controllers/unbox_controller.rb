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
    @machine = Machine.new
    @locations = Location.all.sort_by {|m| m.name.downcase}
    @role = nil

    verify_locations_exist
    if flash[:notice]
      @type = params[:type]
    end

    if flash[:role]
      @role = flash[:flash]
    end

    if flash[:location] && !flash[:location].empty?
      @location = Location.find(flash[:location])
      params[:location] = @location
    elsif params[:location]
      @location = Location.find(params[:location])
    end
  end

  def verify_locations_exist
    if Location.all.empty?
      set_flash('No locations exist', 'error')
      redirect_to locations_index_path
    end
  end

  def can_assign(role)
    return false if role.max_quantity.zero?
    role.quantity + 1 <= role.max_quantity
  end

  def load_schools
    @location = params[:machine][:location]
    flash[:location] = @location
    redirect_to action: 'index'
  end

  def assign
    role_quantity = RoleQuantity.find(params[:machine][:role])
    can_assign = can_assign(role_quantity)
    serial_number = parse(params[:machine][:serial_number])
    flash[:role] = params[:machine][:role]

    if serial_number && can_assign
      machine = Machine.get_machine(serial_number, role_quantity.role)
      asset_tag = params[:machine][:client_asset_tag]
      location = Location.find(params[:location])
      set_flash('Location not found', 'error')
      return return_to_controller if location.nil?

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


  def set_flash(notice, type = 'success')
    location = params[:location]

    if params[:machine]
      existing_role = params[:machine][:role]
    end

    flash[:notice] = notice
    flash[:location] = location
    flash[:type] = type
    flash[:data] = existing_role
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
