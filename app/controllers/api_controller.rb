class ApiController < ApplicationController
  protect_from_forgery with: :null_session
  require 'json'

  def hostname
    serial = params[:serial]
    machine = Machine.where(serial_number: serial)[0]
    if machine
      if machine[:role]
        role = Role.where(name: machine[:role])[0]
        if machine[:location]
          school = School.where(name: machine[:location]).first
          case machine.role
            when "Teacher"
              $ou = school.teacher_ou
            when "Student"
              $ou = school.ou_string
          end
          # Trim Serial to 7 characters
          if school[:blended_learning] && school[:blended_learning] == true
            render json: {'hostname' => "#{school[:school_code]}#{role[:suffix]}BL-#{machine[:serial_number]}", "ou" => $ou}
          else
            render json: {'hostname' => "#{school[:school_code]}#{role[:suffix]}LT-#{machine[:serial_number].split(//).last(7).join}", "ou" => $ou}
          end
        else
          render json: {"error" => "No school found for machine"}
        end
      else
        render json: {"error" => "No role found for machine"}
      end
    else
      render json: {"error" => "No machine found for serial"}
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
      if machine.update(imaged: {"date" => Time.now.strftime("%d/%m/%Y %H:%M"), "imaged" => true})
        render json: {"message" => "Successfully marked as imaged"}
      else
        render json: {"error" => "Invalid serial"}
      end
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

  def reprint
    require 'net/http'
    serial_number = params[:serial]
    existing_machine = Machine.where(serial_number: serial_number).first
    @school_string = existing_machine.location
    @asset_tag = existing_machine.client_asset_tag
    @serial_number = existing_machine.serial_number
    @model = "Dell 3380"
    @type = Role.where(name: existing_machine.role).first.suffix
    if School.where(name: existing_machine.location).first.blended_learning?
      @image_string = "Blended Learning Device"
    else
      @image_string = "Standard Device"
    end
    uri = URI.parse("#{ENV["LABEL_PRINT_SERVER"]}?image=#{@image_string}&asset_number=#{@asset_tag}&serial_number=#{@serial_number.upcase}&school=#{@school_string}&model=#{@model}&type=#{@type}")
    begin
      response = Net::HTTP.get_response(uri)
    rescue
      retry
    end
  end

  def check_imaged
    serial = params[:serial]
    machine = Machine.where(serial_number: serial)[0]
    if machine
      if !machine.imaged
        render json: {imaged: false}
      else
        render json: {imaged: machine.imaged['imaged']}
      end
    else
      render json: {machine: "No machine found for #{serial}"}
    end
  end

  def serial_lookup
    serial = params[:serial]
    machine = Machine.where(serial_number: serial).first
    render json: {found: machine}
  end


  def index

  end
end
