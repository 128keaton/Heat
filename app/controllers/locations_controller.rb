class LocationsController < ApplicationController
  respond_to :html, :xlsx
  before_action :check_for_roles

  def index
    @location = Location.new
    @type = params[:type] unless flash[:notice]
  end

  def destroy
    location = Location.find(params[:id])
    location.destroy
    set_flash('Location deleted successfully', 'success')
    redirect_to action: 'index'
  end

  # Reusable method to set those lovely flash messages
  def set_flash(notice, type = 'success')
    flash[:notice] = notice
    flash[:type] = type
  end

  def manually_override_model
    machine = Machine.find(params[:machine_id])
    @location = Location.find(params[:id])
    if machine && params[:machine].nil?
      @machine = machine
      return render 'locations/model_override'
    elsif machine
      set_flash('Model updated')
      machine.update(model: params[:machine][:model])
    else
      set_flash('Machine not found', 'error')
    end
    redirect_to locations_view_path(id: params[:id])
  end

  def update
    location = find_location
    if location&.valid?
      location.name = params[:location][:name]
      location.is_school = params[:location][:is_school]
      roles = params[:roles]
      Rails.logger.info roles
      location.add_roles(roles)
      set_flash('Location updated')
      location.save!
    else
      set_flash('Location could not be updated', 'error')
    end
    redirect_to locations_index_path
  end

  def find_location
    code = params[:location][:school_code]
    @location = Location.find_by(school_code: code)

    return @location unless @location.nil?
    @location = Location.find_by(name: params[:name])
  end

  def edit
    @location = Location.find(params[:id])
    return unless flash[:notice]
    @type = params[:type]
  end

  def view
    @location = Location.find(params[:id])
  end

  def create
    location = Location.new(location_params)
    if location.valid?
      location.add_roles(params[:roles])
      location.save!
      set_flash('Location created successfully')
    else
      set_flash('Location could not be created', 'error')
    end
    redirect_to action: 'index'
  end

  def deployment_sheet
    location = Location.find(params[:id])
    return false if location.nil?
    return false if location.machines.nil?
    send_data location.machines.to_xlsx,
              filename: "#{location.name}-#{Time.zone.today}.xlsx",
              sheet_name: "#{location.name} - Machines"
  end

  def quantity_override
    @location = Location.find(params[:id])
  end

  def update_quantity
    set_flash('Unable to update quantity', 'error')
    return unless params[:roles]

    roles_quantities = params[:roles]
    roles_quantities.each do |name, rq|
      if (role_quantity = RoleQuantity.find(rq['role_quantity_id']))
        next if role_quantity.set_quantity(rq['quantity'])
        set_flash('Quantity over max', 'error')
        return redirect_to location_quantity_override_path(id: params[:id])
      end
    end

    set_flash('Successfully updated role quantity')
    redirect_to action: 'index'
  end

  def remove_machine
    result = Machine.find(params[:id]).remove_from_location
    type = result.include?('Unable') ? 'error' : 'success'
    set_flash(result, type)
    redirect_to action: 'index'
  end

  private

  def check_for_roles
    return unless Role.all.count.zero?
    set_flash('No roles have been created', 'error')
    redirect_to roles_index_path
  end

  def location_params
    params.require(:location).permit(:name, :school_code, :blended_learning, :quantity, :is_school)
  end
end
