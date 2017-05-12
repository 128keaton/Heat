class NoteController < ApplicationController
  def index
    @machine = Machine.new
  end
  def notate
    notes = params[:machine][:notes]
    if Machine.where(serial_number: params[:machine][:serial_number]).length != 0
			existingMachine = Machine.where(serial_number: params[:machine][:serial_number])
			existingMachine.update(notes: notes)
			flash[:notice] = "Note was attached to machine"
			flash[:type] = "success"
			redirect_to action: 'index'
		else
			flash[:notice] = "Serial number has not been logged"
			flash[:type] = "error"
			redirect_to action: 'index'
		end
  end
end
