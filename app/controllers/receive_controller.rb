class ReceiveController < ApplicationController
  require 'csv'

  def index
    @machine = Machine.new
    @roles = Role.all
    can_receive?
    @po_number = flash[:po_number] if flash[:po_number]
  end

  def can_receive?
    return if @roles.count != 0
    set_flash('No roles exist', 'error')
    return redirect_to roles_index_path if roles.count == 0

    return if FormFactor.all.count != 0
    set_flash('No form factors exist', 'error')
    redirect_to form_factor_index_path
  end

  def machine_exists(serial_number)
    !Machine.find_by(serial_number: serial_number).nil?
  end

  def set_flash(notice, type = 'success')
    flash[:notice] = notice
    flash[:type] = type
  end

  def create
    serial = parse(params[:machine][:serial_number])
    raw_serial = params[:machine][:serial_number]
    flash[:data] = params[:machine][:role]
    flash[:po_number] = params[:machine][:po_number]
    flash[:form_factor] = params[:machine][:form_factor]

    form_factor = FormFactor.find(params[:machine][:form_factor])
    set_flash('Unable to parse serial', 'error')
    return redirect_to action: 'index' if serial.present?&.blank?

    if Machine.exists?(serial_number: serial)
      set_flash('Serial already added', 'error')
    else
      result = Machine.receive(machine_params, raw_serial, form_factor)
      set_flash('Unable to save machine', 'error') if result
      set_flash('Serial has been added')
    end

    redirect_to action: 'index'
  end

  private

  def machine_params
    params.require(:machine).permit(:serial_number, :role, :po_number)
  end

  def parse(serial)
    if serial.include? ','
      serial = CSV.parse(serial.gsub(/\s+/, ''), col_sep: ',')[0][2]
    end
    serial
  end
end
