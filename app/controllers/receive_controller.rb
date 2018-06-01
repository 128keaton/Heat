class ReceiveController < ApplicationController
  before_action :authenticate_user!

  require 'csv'

  def index
    @machine = Machine.new
    @roles = Role.all
    setup_layer_count
    verify_roles_exist

    if flash[:pallet_id]
      @pallet_id = flash[:pallet_id]
    else
      @pallet_id = ''
    end

  end

  def verify_roles_exist
    return if @roles.count != 0
    flash[:notice] = "No roles exist"
    flash[:type] = "error"
    redirect_to "/"
  end

  def setup_layer_count
    if flash[:current_layer_count]
      @current_layer_count = flash[:current_layer_count]
      if @current_layer_count.to_f == 0 || @current_layer_count.to_f < 0
        @layer_count = flash[:layer_count]
        @current_layer_count = @layer_count
      end
    end
  end

  def load_information
    # fetch and set pallet ID
    pallet_id = params[:machine][:pallet_id]
    flash[:pallet_id] = pallet_id

    # Set the Pallet Total Count to what is defined in our role
    role_name = params[:machine][:role]
    role_count = Role.where(name: role_name)
    total_count = role_count[0].pallet_count

    # Set to zero by default, incase nil
    pallet_count_for_id = 0
    if Machine.where(pallet_id: pallet_id).count
      machine_by_pallet = Machine.where(pallet_id: pallet_id)
      pallet_count_for_id = machine_by_pallet.count
    end

    # Set pallet count
    current_pallet_count = total_count.to_f - pallet_count_for_id.to_f
    layer_count = role_count[0].pallet_layer_count

    @current_layer_count = current_pallet_count % layer_count

    if @current_layer_count.to_f == 0 || @current_layer_count.to_f < 0
      @current_layer_count = layer_count
    end
    exit_with(role_name, pallet_id, layer_count, current_pallet_count)

  end

  def exit_with(role_name, pallet_id, layer_count, current_pallet_count)
    if current_pallet_count <= 0
      set_flash('Pallet full', 'error')
    end

    flash[:pallet_id] = pallet_id
    flash[:data] = role_name
    flash[:current_layer_count] = layer_count
    flash[:layer_count] = layer_count
    redirect_to action: 'index'
  end

  # Validate and save the machine
  def validate_and_save(machine, data, pallet_id, layer_count)
    if machine.valid? && machine_exists(machine.serial_number) == false
      machine.save
      set_flash('Serial has been added')
    else
      set_flash('Serial already added', 'error')
    end
    flash[:data] = data
    flash[:current_layer_count] = layer_count
    flash[:pallet_id] = pallet_id
    redirect_to action: 'index'
  end

  # Check if machine exists, should be false!
  def machine_exists(serial_number)
    if Machine.where(serial_number: serial_number).length == 0
      false
    else
      true
    end
  end

  def set_flash(notice, type = 'success')
    flash[:notice] = notice
    flash[:type] = type
  end

  def create
    @machine = Machine.new

    raw_csv = params[:machine][:serial_number]
    serial = CSV.parse(raw_csv.gsub(/\s+/, ''), col_sep: ',')[0][2]
    user_name = current_user.name
    current_date = Time.now.getlocal().strftime('%d/%m/%Y %H:%M')

    if serial.present?
      @machine.unboxed = {"date" => current_date, "user" => user_name}
      @machine.serial_number = serial
      @machine.pallet_id = params[:pallet_id]
      @machine.role = params[:role]

      if @machine.valid? && Machine.where(serial_number: serial).length.zero?
        current_layer_count = params[:current_layer_count].to_f - 1
      else
        current_layer_count = params[:current_layer_count].to_f
      end

      current_role = @machine[:role]
      pallet_id = params[:pallet_id]
      validate_and_save(@machine, current_role, pallet_id, current_layer_count)
    else
      set_flash('Unable to parse serial', 'error')
      flash[:data] = data
      flash[:current_layer_count] = params[:current_layer_count].to_f
      flash[:pallet_id] = params[:pallet_id]
      redirect_to action: 'index'
    end

  end

end
