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

    verify_locations_exist
    if flash[:notice]
      @type = params[:type]
    end

    if !flash[:location].nil?
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
    role.quantity <= role.max_quantity
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

    if serial_number && can_assign
      machine = Machine.get_machine(serial_number, role_quantity.role)
      asset_tag = params[:machine][:client_asset_tag]
      location = Location.find(params[:location])
      set_flash('Location not found', 'error')
      return return_to_controller if location.nil?
      if machine.assign(location, role_quantity, asset_tag)
        print_machine(machine)
        set_flash('Assigned successfully', 'success')
      else
        set_flash("Machine already assigned to #{machine.location}", 'error')
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
    # TODO: Make this an ENV var
    serial_number = machine.serial_number
    school_string = machine.location
    asset_number = machine.client_asset_tag

    type = machine.role[0, 1]
    image_string = 'Standard Device - Special Education'
    uri = URI.parse('http://webapps.nationwidesurplus.com/scs/print'\
                          "?image=#{image_string}"\
                          "&asset_number=#{asset_number}"\
                          "&serial_number=#{serial_number.upcase}"\
                          "&@location=#{school_string}"\
                          "&model=#{machine.get_model_number}&type=#{type}")
    send_print_job(uri)
  end


  def send_print_job(uri)
    begin
      response = Net::HTTP.get_response(uri)
    rescue Errno::EINVAL, Errno::ECONNRESET, EOFError,
        Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError,
        Net::ProtocolError => e
      puts e
      retry
    rescue Timeout::Error
      set_flash("Upload timed out", "error")
    end

    if response
      set_flash("Machine was assigned", "success")
    else
      set_flash("Label unable to be printed", "success")
    end
  end

  def set_flash(notice, type = 'success')
    school = params[:location]
    if params&& params[:machine]
      existing_role = params[:machine][:role]
    end

    flash[:notice] = notice
    flash[:location] = school
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
