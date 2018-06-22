class InventoryController < ApplicationController
  def index
  end

  def add
    serial_number = params[:add][:serial_number]
    inventory_location = params[:add][:inventory_location]

    if (machine = Machine.find_by(serial_number: serial_number))
      machine.update(inventory_location: inventory_location)
      set_flash('Machine successfully added to inventory')
    else
      set_flash('Machine not found' ,'error')
    end
    redirect_to action: 'index'
  end

  def remove
    id = params[:id]
    Machine.find(id).update(inventory_location: nil)
    redirect_to action: 'index'
  end

  def find
    serial = params[:serial_number]
    render json: Machine.where('serial_number ILIKE :in AND inventory_location IS NOT NULL', in: "%#{serial}%")
  end

  private

  def set_flash(notice, type = 'success')
    flash[:notice] = notice
    flash[:type] = type
  end
end
