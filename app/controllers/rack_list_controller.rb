class RackListController < ApplicationController
  before_action :authenticate_user!
  def index
    if !current_user.try(:supervisor?)
      flash[:notice] = "You need to be an administrator"
      flash[:type] = "error"
       redirect_to "/"
    end
    @rack = RackCart.new
  end

  def create
    @rack = RackCart.new(rack_params)

    if @rack.valid?
       @rack.save
       set_flash('Rack created successfully')
    else
      set_flash('Rack could not be created', 'error')
    end
    redirect_to action: 'index'
  end

  # Reusable method to set those lovely flash messages
  def set_flash(notice, type = 'success')
    flash[:notice] = notice
    flash[:type] = type
  end

  private

  def rack_params
    params.require(:rack_cart).permit(:rack_id, :capacity)
  end


end
