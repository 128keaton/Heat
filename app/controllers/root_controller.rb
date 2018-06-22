class RootController < ApplicationController
  before_action :authenticate_user!
  def mark_doa
    serial_number = params[:machine][:serial_number]
    if (machine = Machine.find_by(serial_number: serial_number))
      machine.mark_doa(params[:machine][:doa])
      set_flash('Machine was marked as DOA')
    else
      set_flash('Machine not found', 'error')
    end
    redirect_to action: 'index'
  end

  def set_flash(notice, type = 'success')
    flash[:notice] = notice
    flash[:type] = type
  end

end
