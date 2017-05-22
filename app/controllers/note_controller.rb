class NoteController < ApplicationController
  def index
    @machine = Machine.new
  end
  def notate
    notes = params[:machine][:notes]
		serial_number =  params[:machine][:serial_number]
		machine_array = Machine.where(serial_number: serial_number)
    if existing_machine = machine_array[0]
			existing_machine.update(notes: notes)
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
