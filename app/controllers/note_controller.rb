class NoteController < ApplicationController
  def index
    @machine = Machine.new
  end
  def notate
    notes = params[:machine][:notes]
    if Machine.where(serial_number: params[:machine][:serial_number]).length != 0
			existingMachine = Machine.where(serial_number: params[:machine][:serial_number])
			existingMachine.update(notes: notes)
			flash[:notice] = "Machine was notated"
			redirect_to action: 'index', type: "success"
		else
			flash[:notice] = "Serial number was not added beforehand"
			redirect_to action: 'index', type: "error"
		end
  end
end
