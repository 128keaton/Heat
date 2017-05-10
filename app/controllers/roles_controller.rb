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
    redirect_to controller: 'roles', action: 'index', type: "success"
  end

  def create
     specsHash =  {'cpu' => params[:cpu], 'hdd' => params[:hdd], 'ram' => params[:ram], }
     @role = Role.new()
     @role.specs = specsHash
     @role.name = params[:role][:name]
     @role.suffix = params[:role][:suffix]

    if @role.valid?
       @role.save
       flash[:notice] = "Role created successfully"
       redirect_to controller: 'roles', action: 'index', type: "success"
    else
      flash[:notice] = "Role could not be created"
      redirect_to controller: 'roles', action: 'index', type: "error"
    end
  end
end
