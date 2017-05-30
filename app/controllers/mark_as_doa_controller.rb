class MarkAsDoaController < ApplicationController
  def index
    if !current_user.try(:admin?) || !current_user.try(:supervisor?)
      set_flash('You need to be an administrator', 'error')
      redirect_to "/"
    end
    @machine = Machine.new
  end
  def mark_doa
    doa = params[:machine][:doa]
		serial_number = params[:machine][:serial_number]
		machine_array = Machine.where(serial_number: serial_number)
    if existing_machine = machine_array[0]
			existing_machine.update(doa: doa, unboxed: nil, imaged: nil, racked: nil, deployed: nil, location: nil, rack: nil)
      set_flash('Machine was marked as DOA')
		else
      set_flash('Machine was not marked as DOA', 'error')
		end
    redirect_to action: 'index'
  end

  def set_flash(notice, type = 'success')
    flash[:notice] = notice
    flash[:type] = type
  end

end
