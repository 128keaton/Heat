class ReceiveController < ApplicationController
  before_action :authenticate_user!

  def index
    @machine = Machine.new
    @roles = Role.all
    if flash[:pallet_id]
      @pallet_id = flash[:pallet_id]
    else
      @pallet_id = ""
    end

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
    role_name =  params[:machine][:role]
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
    exit_with(role_name, pallet_id, layer_count, current_pallet_count, nil)

  end

def exit_with(data, pallet_id, layer_count, current_pallet_count, machine)
  if current_pallet_count
      if current_pallet_count <= 0 
        flash[:notice] = "Pallet full"
        flash[:data] = data
        flash[:pallet_id] = pallet_id 
        flash[:type] = "error"
        redirect_to action: 'index'
        flash[:layer_count] = layer_count
      else
        redirect_to action: 'index'
        flash[:pallet_id] = pallet_id 
        flash[:data] = data
        flash[:current_layer_count] = layer_count
        flash[:layer_count] = layer_count
      end
  else
    if machine.valid? && Machine.where(serial_number: machine.serial_number).length == 0
       machine.save
        flash[:notice] = "Serial has been added."
        flash[:data] = data
        flash[:type] = "success"
        flash[:current_layer_count] = layer_count
        flash[:pallet_id] = pallet_id
        redirect_to action: 'index'
    else
        flash[:notice] = "Serial already added"
        flash[:data] = data
        flash[:type] = "error"
        flash[:current_layer_count] = layer_count
        flash[:pallet_id] = pallet_id
        redirect_to action: 'index'
    end
  end
end

  def create
    @machine = Machine.new()

    user_name = current_user.name
    current_date = Time.now.strftime("%d/%m/%Y %H:%M")

    @machine.unboxed =  {"date" => current_date, "user" => user_name}
    @machine.serial_number = params[:machine][:serial_number]
    @machine.pallet_id = params[:pallet_id]
    @machine.role = params[:role]

    if @machine.valid? && Machine.where(serial_number: machine.serial_number).length == 0
      current_layer_count = params[:current_layer_count].to_f - 1
    else
      current_layer_count = params[:current_layer_count].to_f
    end

    current_role = @machine[:role]
    pallet_id = params[:pallet_id]
    exit_with(current_role, pallet_id, current_layer_count, nil, @machine)
  end


end
