class SchoolsController < ApplicationController
  before_action :authenticate_user!
  respond_to :html, :xlsx

  def index
    @school = School.new
    @type = params[:type] unless flash[:notice]
  end

  def destroy
    school = School.find(params[:id])
    school.destroy
    set_flash('School deleted successfully', 'success')
    redirect_to action: 'index'
  end

  # Reusable method to set those lovely flash messages
  def set_flash(notice, type = 'success')
    flash[:notice] = notice
    flash[:type] = type
  end

  def update
    school = find_school
    if school&.valid?
      school.name = params[:school][:name]
      school.add_roles(params[:roles])
      school.save
      set_flash('School updated successfully')
    else
      set_flash('School could not be updated', 'error')
    end
    redirect_to action: 'index'
  end

  # Try to locate school first by code, then by name
  def find_school
    school_code = params[:school][:school_code]
    school_array = School.where(school_code: school_code)
    @school = school_array[0]

    unless @school
      @school = School.where(name: params[:name])[0]
    end

    @school.set_school_code(params[:school][:school_code])
    @school
  end

  def edit
    @school = School.find(params[:id])
    if flash[:notice]
      @type = params[:type]
    end
  end

  def view
    @school = School.find(params[:id])
  end

  def create
    school = School.new(school_params)
    if school.valid?
      school.add_roles(params[:roles])
      school.save
      set_flash('School created successfully')
    else
      set_flash('School could not be created', 'error')
    end
    redirect_to action: 'index'
  end

  def deployment_sheet
    location = School.find(params[:id]).name
    return false if location.nil?
    machines = Machine.where(location: location)
    return false if machines.nil?
    send_data machines.to_xlsx,
              filename: "#{location}-#{Time.zone.today}.xlsx"
  end

  private

  def school_params
    params.require(:school).permit(:name, :school_code, :blended_learning, :quantity)
  end
end
