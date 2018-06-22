class InventoryController < ApplicationController
  def index
    @machines =  Machine.where("inventory_location IS NOT NULL")
  end

  def add
    serial_number = params[:add][:serial_number]
    if serial_number.include? ','
      serial_number = CSV.parse(serial_number.gsub(/\s+/, ''), col_sep: ',')[0][2]
    end

    inventory_location = params[:add][:inventory_location]
    machine = Machine.find_by(serial_number: serial_number)

    if machine&.inventory_location.nil?
      machine.update(inventory_location: inventory_location)
      set_flash('Machine successfully added to inventory')
    elsif !machine.inventory_location.nil?
      set_flash('Machine already in inventory', 'error')
    elsif inventory_location&.empty?
      set_flash('Inventory location cannot be empty', 'error')
    else
      set_flash('Machine not found', 'error')
    end
    redirect_to action: 'index'
  end

  def remove
    id = params[:id]
    Machine.find(id).update(inventory_location: nil)
    redirect_to action: 'index'
  end

  def find
    serial_number = params[:serial_number]
    if serial_number.include? ','
      serial_number = CSV.parse(serial_number.gsub(/\s+/, ''), col_sep: ',')[0][2]
    end

    render json: Machine.where('serial_number ILIKE :in AND inventory_location IS NOT NULL',
                               in: "%#{serial_number}%")
  end

  private

  def set_flash(notice, type = 'success')
    flash[:notice] = notice
    flash[:type] = type
  end
end
