require 'net/http'
require 'csv'

class SchoolController < ApplicationController

  def export
    @school = params[:school]
    @machines = Machine.where(location: params[:school]).order(:client_asset_tag)
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
      format.csv {send_data @send_csv, filename: "#{@school}-#{Date.today}.csv"}
    end
  end

  before_action :authenticate_user!

  def index
    @machine = Machine.new
    @schools = School.all.sort_by {|m| m.name.downcase}

    verify_schools_exist
    if flash[:notice]
      @type = params[:type]
    end
    if flash[:school] != ""
      @school = flash[:school]
      params[:school] = @school
    elsif params[:school]
      @school = params[:school]
    end
  end

  def verify_schools_exist
    return if @schools.count != 0
    flash[:notice] = "No schools exist"
    flash[:type] = "error"
    redirect_to "/"
  end

  def can_assign(role)
    role.quantity <= role.max_quantity
  end

  def load_schools
    @school = params[:machine][:location]
    flash[:school] = @school
    redirect_to controller: 'school', action: 'index'
  end

  def assign
    role_quantity = RoleQuantity.find(params[:machine][:role])
    can_assign = can_assign(role_quantity)
    raw_csv = params[:machine][:serial_number]
    serial_number = CSV.parse(raw_csv.gsub(/\s+/, ''), col_sep: ',')[0][2]

    if serial_number && can_assign
      machine = Machine.get_machine(serial_number)
      asset_tag = params[:machine][:client_asset_tag]
      school = params[:school]
      if machine.assign(school, role_quantity, asset_tag)
        set_flash('Assigned successfully', 'success')
      else
        set_flash("Machine already assigned to #{machine.location}", 'error')
      end
    elsif can_assign
      set_flash('Serial not set. Please try again', 'error')
    else
      set_flash('All computers assigned to role', 'error')
    end
    redirect_to action: 'index', school: params[:school]
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
                          "&school=#{school_string}"\
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

  def set_flash(notice, type)
    school = params[:school]
    existing_role = params[:machine][:role]

    flash[:notice] = notice
    flash[:school] = school
    flash[:type] = type
    flash[:data] = existing_role
  end

  private

  def machine_params
    params.require(:machine).permit(:location, :serial_number)
  end
end
