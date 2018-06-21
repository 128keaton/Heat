class ApiController < ApplicationController
  protect_from_forgery with: :null_session
  require 'json'
  require 'net/http'

  def hostname
    serial = params[:serial]
    machine = Machine.where(serial_number: serial).first
    check_machine(machine)

    school = School.where(name: machine[:location]).first
    ou = school.find_ou_for_role(machine[:role])

    # Trim Serial to 7 characters
    if school[:blended_learning] && school[:blended_learning] == true
      render json: {hostname: "#{school[:school_code]}#{role[:suffix]}BL-#{machine[:serial_number]}",
                    ou: ou}
    else
      render json: {hostname: "#{school[:school_code]}#{role[:suffix]}LT-#{machine[:serial_number].split(//).last(7).join}",
                    ou: ou}
    end
  end

  def image
    serial = params[:serial]
    machine = Machine.where(serial_number: serial)[0]
    if machine
      school = School.where(name: machine[:location])[0]
      if school
        role = machine[:role]
        if role
          if school[:blended_learning] && school[:blended_learning] == true
            render json: {'image-name' => "blended_learning/#{role}"}
          else
            render json: {'image-name' => "standard/#{role}"}
          end
        else
          # no role
          render json: {"error" => "No role found for machine"}
        end
      else
        # no school
        render json: {"error" => "No school found for machine"}
      end
    else
      render json: {"error" => "No machine found for serial"}
    end
  end

  def mark_as_deployed
    serial = params[:serial]
    app_key = Rails.configuration.api['key']
    sent_key = params[:key]
    machine = Machine.where(serial_number: serial)[0]
    if machine
      school = School.where(name: machine[:location])[0]
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
        # no school
        render json: {"error" => "No school found for machine"}
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
      school = School.where(name: machine[:location])[0]
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
        # no school
        render json: {"error" => "No school found for machine"}
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
      school_string = machine.location
      asset_number = machine.client_asset_tag

      type = machine.role[0, 1]
      image_string = 'Standard Device - Special Education'

      # TODO: Make this an ENV var
      uri = URI.parse("http://webapps.nationwidesurplus.com/scs/print?image=#{image_string}&asset_number=#{asset_number}&serial_number=#{serial.upcase}&school=#{school_string}&model=#{machine.get_model_number}&type=#{type}")

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

    location = School.search_by(location_id, location_search, location_code)
    render_location(location, format)
  end

  def render_location(location, format = 'json')
    if location&.is_a? School
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

  def check_machine(machine)
    if machine.nil?
      render json: {status: 'error',
                    code: '471',
                    message: 'Machine not found'} && return
    elsif machine.role.nil?
      render json: {status: 'error',
                    code: '470',
                    message: 'Role not found for machine'} && return
    elsif machine.location.nil?
      render json: {status: 'error',
                    code: '472',
                    message: 'Location not found for machine'} && return
    end
  end


end
