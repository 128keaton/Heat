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
    @roles = Role.all
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

  def get_quantity_for(location, role)
    @machineArray = Machine.where(location: location, role: role)
    return @machineArray.length
  end

  def automatic_assignment(location)
    if get_quantity_for(location, "Teacher") < School.where(name: location)[0].quantity["Teacher"].to_i
      return "Teacher"
    elsif get_quantity_for(location, "Student") < School.where(name: location)[0].quantity["Student"].to_i
      return "Student"
    else
      return "Full"
    end

  end

  def load_schools
    @school = params[:machine][:location]
    flash[:school] = @school
    redirect_to controller: 'school', action: 'index'
  end

  def build_reply(machine)
    current_date = Time.now.strftime("%d/%m/%Y %H:%M")

    unboxed = {"date" => current_date, "user" => current_user.name}

    role = machine[:role]
    passed_role = params[:machine][:role]


    if passed_role && passed_role != ""
      role = passed_role
    end

    machine.update(location: params[:school], unboxed: unboxed, role: role)
  end

  def assign
    raw_csv = params[:machine][:serial_number]
    serial_number = CSV.parse(raw_csv.gsub(/\s+/, ''), col_sep: ',')[0][2]
    machine_array = Machine.where(serial_number: serial_number)
    assignment = automatic_assignment(params[:school])

    if (machine = machine_array.first)
      build_reply(machine)
      school_string = machine.location
      asset_number = machine.client_asset_tag

      type = machine.role[0, 1]
      image_string = 'Standard Device - Special Education'

      # TODO: Make this an ENV var
      uri = URI.parse('http://webapps.nationwidesurplus.com/scs/print'\
                          "?image=#{image_string}"\
                          "&asset_number=#{asset_number}"\
                          "&serial_number=#{serial_number.upcase}"\
                          "&school=#{school_string}"\
                          "&model=#{machine.get_model_number}&type=#{type}")
      begin
        response = Net::HTTP.get_response(uri)
      rescue Errno::EINVAL, Errno::ECONNRESET, EOFError,
             Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError,
             Net::ProtocolError => e
        logger.error e
        retry
      rescue Timeout::Error
        set_flash("Upload timed out", "error")
      end

      if response
        set_flash("Machine was assigned", "success")
      else
        set_flash("Label unable to be printed", "success")
      end
      redirect_to action: 'index', school: params[:school]
    elsif assignment != "Full"
      current_date = Time.now.strftime("%d/%m/%Y %H:%M")
      unboxed = {"date" => current_date, "user" => current_user.name}

      role = assignment
      passed_role = params[:machine][:role]
      if passed_role && passed_role != ''
        role = passed_role
      end

      Machine.create(serial_number: serial_number, location: params[:school], unboxed: unboxed, role: role, client_asset_tag: params[:machine][:client_asset_tag])

      school_string = machine.location
      asset_number = machine.client_asset_tag

      type = machine.role[0, 1]
      image_string = 'Standard Device - Special Education'

      # TODO: Make this an ENV var
      uri = URI.parse('http://webapps.nationwidesurplus.com/scs/print'\
                          "?image=#{image_string}"\
                          "&asset_number=#{asset_number}"\
                          "&serial_number=#{serial_number.upcase}"\
                          "&school=#{school_string}"\
                          "&model=#{machine.get_model_number}&type=#{type}")
      begin
        response = Net::HTTP.get_response(uri)
      rescue Errno::EINVAL, Errno::ECONNRESET, EOFError,
             Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError,
             Net::ProtocolError => e
        logger.error e
        retry
      rescue Timeout::Error
        set_flash("Upload timed out", "error")
      end

      if response
        set_flash("Machine was assigned", "success")
      else
        set_flash("Label unable to be printed", "success")
      end
      redirect_to action: 'index', school: params[:school]
    else
      set_flash("School has been assigned all units!", "error")
      redirect_to action: 'index', school: params[:school]
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

  helper_method :get_quantity_for

  private

  def machine_params
    params.require(:machine).permit(:location, :serial_number)
  end
end
