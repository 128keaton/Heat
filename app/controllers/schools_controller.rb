class SchoolsController < ApplicationController
  before_action :authenticate_user!
  def index
    if !current_user.try(:admin?)
      flash[:notice] = "You need to be an administrator"
      flash[:type] = "error"
       redirect_to "/"
    end
    @school = School.new
    @roles = Role.all
    if flash[:notice]
      @type = params[:type]
    end
  end

 def destroy
   # time to blow up the school :D
   @school = School.find(params[:id])
   @school.destroy
   set_flash('School deleted successfully', 'success')
   redirect_to action: 'index'
  end

  # Reusable method to set those lovely flash messages
  def set_flash(notice, type = 'success')
    flash[:notice] = notice
    flash[:type] = type
  end

  def update
    find_school
    return if @school.nil?
    @school.quantity = update_quantity(@school)
    if @school.valid?
       @school.save
      set_flash('School updated successfully')
    else
      set_flash('School could not be updated', 'error')
    end
    redirect_to action: 'index'
  end
  
  # Try to locate school first by code, then by name
  def find_school
    @school = School.where(school_code: params[:school][:school_code])[0]
     if @school == nil
        @school = School.where(name: params[:name])[0]
     end
     school_code(@school)
  end

  def school_code(school)
      if params[:school][:school_code]
        school.school_code = params[:school][:school_code]
     end
  end

  def edit
    @school = School.find(params[:id])
    @roles = Role.all

    validate(@school)

    if flash[:notice]
      @type = params[:type]
    end
  end

  def update_quantity(school)
    quantities = {}
    Role.all.each do |role|
      quantities[role.name] = params["#{role.name}-role"]
    end
    quantities
  end

  def validate(school)
    quantities = {}
    Role.all.each do |role|
     if !@school[:quantity][role.name] 
         quantities[role.name] = "0"
      end
    end

    if quantities != {}
      @school.update(quantity: quantities)
    end
  end

  def create
     @school = School.new(school_params)
     quantities = {}
     Role.all.each do |role|
      quantities[role.name] = params["#{role.name}-role"]
     end
     @school.quantity = quantities
    if @school.valid?
       @school.save
       flash[:notice] = "School created successfully"
       flash[:type] = "success"
       redirect_to action: 'index'
    else
      flash[:notice] = "School could not be created"
      flash[:type] = "error"
      redirect_to action: 'index'
    end
  end

  private

  def school_params
    params.require(:school).permit(:name, :school_code, :blended_learning, :quantity)
  end
end
