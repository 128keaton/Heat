class RolesController < ApplicationController
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
     @role = Role.new(role_params)
    if @role.valid?
       @role.save
       flash[:notice] = "Role created successfully"
       redirect_to controller: 'roles', action: 'index', type: "success"
    else
      flash[:notice] = "Role could not be created"
      redirect_to controller: 'roles', action: 'index', type: "error"
    end
  end

  private

  def role_params
    params.require(:role).permit(:name, :specs, :suffix)
  end
end
