class RolesController < ApplicationController
  before_action :authenticate_user!
  def index
    @role = Role.new
    if flash[:notice]
      @type = params[:type]
    end
  end

  def destroy
    @role = Role.find(params[:id])
    @role.destroy
    flash[:notice] = "Role deleted successfully"
    flash[:type] = "success"
    redirect_to action: 'index'
  end

  def create
     specsHash =  {'cpu' => params[:cpu], 'hdd' => params[:hdd], 'ram' => params[:ram] }
     @role = Role.new()
     @role.specs = specsHash
     @role.name = params[:role][:name]
     @role.suffix = params[:role][:suffix]

    if @role.valid?
       @role.save
       flash[:notice] = "Role created successfully"
       flash[:type] = "success"
       redirect_to action: 'index'
    else
      flash[:notice] = "Role could not be created"
      flash[:type] = "error"
      redirect_to action: 'index'
    end
  end
end
