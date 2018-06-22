class RolesController < ApplicationController
  before_action :authenticate_user!

  def index
    if !current_user.try(:admin?)
      flash[:notice] = "You need to be an administrator"
      flash[:type] = "error"
      redirect_to "/"
    end

    @role = Role.new
    if flash[:notice]
      @type = params[:type]
    end
  end

  def destroy
    @role = Role.find(params[:id]).destroy
    flash[:notice] = "Role deleted successfully"
    flash[:type] = "success"
    redirect_to action: 'index'
  end

  def create
    specsHash = {'cpu' => params[:cpu], 'hdd' => params[:hdd], 'ram' => params[:ram]}
    @role = Role.new()
    @role.specs = specsHash
    @role.name = params[:role][:name]
    @role.suffix = params[:role][:suffix]
    @role.pallet_count = params[:role][:pallet_count]
    @role.pallet_layer_count = params[:role][:pallet_layer_count]

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

  def list_roles
    render json: Role.all
  end

  def list_location_roles
    id = params[:id]
    render json: {roles: Role.all, checked:  Role.joins(:role_quantities).where(role_quantities: {school_id: id})}
  end

end
