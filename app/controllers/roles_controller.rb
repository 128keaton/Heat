class RolesController < ApplicationController

  def index
    @role = Role.new
    @type = params[:type] if flash[:notice]
  end

  def edit
    @role = Role.find(params[:id])
    redirect_to roles_index_path if @role.nil?
  end

  def update
    set_flash('Role unable to be updated', 'error')
    set_flash('Role updated successfully') if Role.find(params[:id]).update(role_params)
    redirect_to roles_index_path
  end

  def destroy
    set_flash('Role deleted successfully') if Role.find(params[:id]).destroy
    redirect_to roles_index_path
  end

  def create
    set_flash('Role could not be created', 'error')
    set_flash('Role created successfully') if Role.create(role_params).save
    redirect_to roles_index_path
  end

  def list_roles
    render json: Role.all
  end

  def list_location_roles
    id = params[:id]
    render json: {roles: Role.all, checked: Role.joins(:role_quantities).where(role_quantities: {school_id: id})}
  end

  private

  def set_flash(notice, type = 'success')
    flash[:notice] = notice
    flash[:type] = type
  end

  def role_params
    params.require(:role).permit(:product, :name, :suffix)
  end
end
