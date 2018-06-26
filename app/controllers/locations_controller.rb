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

  def update
    location = find_location
    if location&.valid?
      location.name = params[:location][:name]
      roles = params[:roles]
      set_flash('Location updated successfully')
      set_flash('Location not updated successfully', 'error') if location.add_roles(roles)
      location.save!
    else
      set_flash('Location could not be updated', 'error')
    end
    redirect_to action: 'index'
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
    location = Location.find(params[:id]).name
    return false if location.nil?
    machines = Machine.where(location: location)
    return false if machines.nil?
    send_data machines.to_xlsx,
              filename: "#{location}-#{Time.zone.today}.xlsx"
  end

  private

  def check_for_roles
    return unless Role.all.count.zero?
    set_flash('No roles have been created', 'error')
    redirect_to roles_index_path
  end

  def location_params
    params.require(:location).permit(:name, :school_code, :blended_learning, :quantity)
  end
end
