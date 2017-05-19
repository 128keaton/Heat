class MarkAsDoaController < ApplicationController
  def index
    if !current_user.try(:admin?)
      flash[:notice] = "You need to be an administrator"
      flash[:type] = "error"
       redirect_to "/"
    end
    @machine = Machine.new
  end
  def mark_doa
    doa = params[:machine][:doa]
    if Machine.where(serial_number: params[:machine][:serial_number]).length != 0
			existingMachine = Machine.where(serial_number: params[:machine][:serial_number])
			existingMachine.update(doa: doa)
			flash[:notice] = "Machine was marked as DOA"
			flash[:type] = "success"
			redirect_to action: 'index'
		else
			flash[:notice] = "Machine was marked as DOA"
			flash[:type] = "error"
			redirect_to action: 'index'
		end
    end
end
