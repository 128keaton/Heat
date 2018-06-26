class ApiController < ApplicationController
  protect_from_forgery with: :null_session
  require 'json'
  require 'net/http'

  def hostname
    serial = params[:serial]
    return send_error('No serial sent') if serial.nil?
    machine = Machine.find_by(serial_number: serial)
    return send_error("No machine found for #{serial}") if machine.nil?
    check_machine(machine)
    school = Location.find(machine[:location_id])
    return send_error('No school found') if school.nil?
    return send_error('No role for machine') if machine.role.nil?

    ou = school.find_ou_for_role(machine.role)
    render json: {hostname: machine.hostname, ou: ou}
  end

  def image
    serial = params[:serial]
    if serial&.present?
      machine = Machine.find_by(serial_number: serial)
      check_machine(machine)
      school = Location.find_by(name: machine[:location])
      if school&.blended_learning
        render json: {'image-name' => "blended_learning/#{role}"}
      elsif school&.blended_learning.nil? or school&.blended_learning == false
        render json: {'image-name' => "standard/#{role}"}
      elsif school.nil?
        render json: {status: 'error',
                      code: '420',
                      message: 'No @location found'}
      end
    else
      render json: {status: 'error',
                    code: '6969',
                    message: 'No serial passed'}
    end
  end

  def mark_as_deployed
    serial = params[:serial]
    app_key = Rails.configuration.api['key']
    sent_key = params[:key]
    machine = Machine.where(serial_number: serial)[0]
    if machine
      school = Location.where(name: machine[:location])[0]
      if school
        role = machine[:role]
        if role
          if sent_key == app_key
            machine.update(deployed: {"date" => Time.now.strftime("%d/%m/%Y %H:%M"), "deployed" => true}, doa: false)
            render json: {"message" => "Successfully marked as deployed"}
          else
            render json: {"error" => "Invalid key"}
          end
        else
          # no role
          render json: {"error" => "No role found for machine"}
        end
      else
        # no @location
        render json: {"error" => "No @location found for machine"}
      end
    else
      render json: {"error" => "No machine found for serial"}
    end
  end

  def set_imaged
    serial = params[:serial]
    machine = Machine.where(serial_number: serial)[0]
    if machine
      if (status = machine.set_imaged)
        render json: {message: 'Successfully marked as imaged', machine: machine}
      else
        render json: {status: "error", code: 3000, message: "Unable to set params #{status}", machine: machine}
      end
    elsif serial == '' or !defined? serial
      render json: {status: "error", code: 3000, message: "No serial in params"}
    else
      render json: {status: "error", code: 3000, message: "No machine found by serial #{serial}"}
    end
  end

  def set_asset_tag
    serial = params[:serial]
    asset_tag = params[:asset_tag]
    machine = Machine.where(serial_number: serial)[0]
    if machine
      school = Location.where(name: machine[:location])[0]
      if school
        role = machine[:role]
        if role
          if asset_tag
            machine.update(client_asset_tag: asset_tag)
            render json: {"message" => "Successfully set asset tag"}
          else
            # no tag
            render json: {"error" => "No asset tag passed"}
          end
        else
          # no role
          render json: {"error" => "No role found for machine"}
        end
      else
        # no @location
        render json: {"error" => "No @location found for machine"}
      end
    else
      render json: {"error" => "No machine found for serial"}
    end
  end

  def render_as_csv
    @machines = Machine.all.order(:location)
    send_data @machines.to_csv, filename: "status-#{Date.today}.csv"
  end

# Prints a label for a machine based on serial
  def print_label(serial)
    if (machine = Machine.where(serial_number: serial).first)
      school_string = machine.location.name
      asset_number = machine.client_asset_tag

      type = machine.role[0, 1]
      image_string = 'Standard Device - Special Education'

      # TODO: Make this an ENV var
      uri = URI.parse("http://webapps.nationwidesurplus.com/scs/print?image=#{image_string}&asset_number=#{asset_number}&serial_number=#{serial.upcase}&@location=#{school_string}&model=#{machine.get_model_number}&type=#{type}")

      begin
        response = Net::HTTP.get_response(uri)
      rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
          Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError,
          Net::ProtocolError => e
        logger.error e
        retry
      end

      render json: response
    else
      render json: {status: 'error', code: 3000, message: "No machine found for #{serial}"}
    end
  end

  def reprint
    print_label(params[:serial])
  end

  def check_imaged
    serial = params[:serial]
    machine = Machine.where(serial_number: serial)[0]
    if machine && serial != ''
      if !machine.imaged
        render json: {imaged: false, machine: machine, message: 'Machine is not imaged'}
      else
        render json: {imaged: machine.imaged['imaged'], machine: machine, message: 'Machine is imaged'}
      end
    else
      render json: {status: "error", code: 3000, message: "No machine found for #{serial}"}
    end
  end

  def location_quantity
    location_id = params[:id]
    location_search = params[:name]
    location_code = params[:code]
    format = params[:format] || 'json'

    location = Location.search_by(location_id, location_search, location_code)
    render_location(location, format)
  end

  def render_location(location, format = 'json')
    if location&.is_a? Location
      if format == 'json'
        render json: location.render_machines
      else
        send_data location.render_machines(format)
      end
    else
      render json: {status: 'error', code: '472', message: 'Location not found'}
    end
  end

  def serial_lookup
    serial = params[:serial]
    machine = Machine.where(serial_number: serial).first
    render json: {found: machine}
  end


  private

  def send_error(message)
    render json: {status: 'error',
                  message: message}
    return
  end

  def check_machine(machine)
    if machine.nil?
      send_error("No machine found for machine with serial #{machine.serial_number}")
    elsif machine.role.nil?
      send_error("No role found for machine with serial #{machine.serial_number}")
    elsif machine.location.nil?
      send_error("No location found for machine with serial #{machine.serial_number}")
    end
  end


end
