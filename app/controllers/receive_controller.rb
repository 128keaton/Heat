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
  
    pallet_id = params[:machine][:pallet_id]
    flash[:pallet_id] = pallet_id

    # Set the Pallet Total Count to what is defined in our role
    total_count = Role.where(name: params[:machine][:role])[0].pallet_count

    # Set to zero by default, incase nil
    pallet_count_for_id = 0
    if Machine.where(pallet_id: pallet_id).count
      pallet_count_for_id = Machine.where(pallet_id: pallet_id).count
    end

    current_pallet_count = total_count.to_f - pallet_count_for_id.to_f
    layer_count = Role.where(name: params[:machine][:role])[0].pallet_layer_count
    @current_layer_count = current_pallet_count % layer_count

    if @current_layer_count.to_f == 0 || @current_layer_count.to_f < 0
      @current_layer_count = layer_count 
    end

    if current_pallet_count <= 0 
        flash[:notice] = "Pallet full"
        flash[:data] = params[:machine][:role]
        flash[:pallet_id] = pallet_id 
        flash[:type] = "error"
        redirect_to action: 'index'
        flash[:layer_count] = layer_count
    else
       redirect_to action: 'index'
       flash[:pallet_id] = pallet_id 
       flash[:data] = params[:machine][:role]
       flash[:current_layer_count] = @current_layer_count
       flash[:layer_count] = layer_count
    end
    #test_hash = {"Current Layer Count" => @current_layer_count, "Laptops scanned from pallet" => pallet_count_for_id, "Pallet TOTAL count" => total_count, "Laptops left on pallet" => current_pallet_count, "Layer count as reported from roles" => layer_count}
    
  end
  def create
    @machine = Machine.new()

    @machine.unboxed =  {"date" => Time.now.strftime("%d/%m/%Y %H:%M"), "user" => current_user.name}
    @machine.serial_number = params[:machine][:serial_number]
    @machine.pallet_id = params[:pallet_id]
    @machine.role = params[:role]
    # Checks if the machine is valid
    if @machine.valid?
       # Saves the machine
       @machine.save
        flash[:notice] = "Serial has been added."
        flash[:data] = @machine[:role]
        flash[:type] = "success"
        flash[:current_layer_count] = params[:current_layer_count].to_f - 1
        flash[:pallet_id] = params[:pallet_id]
        redirect_to action: 'index'
    else
        flash[:notice] = "Serial already added"
        flash[:data] = @machine[:role]
        flash[:type] = "error"
        flash[:current_layer_count] = params[:current_layer_count]
        flash[:pallet_id] = params[:pallet_id]
        redirect_to action: 'index'
    end

  end


end
