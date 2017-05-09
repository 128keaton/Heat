class ApiController < ApplicationController
  protect_from_forgery with: :null_session
  def hostname
    serial = params[:serial]
    machine = Machine.where(serial_number: serial)
    render json: machine
  end

  def image
    serial = params[:serial]
    machine = Machine.where(serial_number: serial)[0]
    imageName = {}
    role = machine[:role]
    if machine[:blendedLearning] && machine[:blendedLearning] == true
      imageName = {'image-name' => "blendedLearning/ #{ role.downcase }"}
    else
      imageName = {'image-name' => "standard/#{role.downcase}"}
    end
 
    render json: imageName
  end

  def index

  end
end
