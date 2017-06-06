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
       @school.ou_string = params[:ou_string]
       @school.teacher_ou = params[:teacher_ou]
       @school.save
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
    if @school == nil
      @school = School.where(name: params[:name])[0]
    end
    # Sets the school code
    school_code(@school)
  end

  def school_code(school)
    return if params[:school][:school_code].nil?
    school.school_code = params[:school][:school_code]
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

  def view
     @school = School.find(params[:id])
  end


  def validate(school)
    quantities = {}
    Role.all.each do |role|
     if !@school[:quantity][role.name] 
        quantities[role.name] = "0"
      else
        quantities[role.name] = @school[:quantity][role.name] 
      end
    end

    if quantities != {}
      @school.update(quantity: quantities)
    end
  end

  def create
    #Check here if there's no OU stuff
     @school = School.new(school_params)
     quantities = {}
     Role.all.each do |role|
      param_role =  params["#{role.name}-role"]
      quantities[role.name] = param_role
     end

     @school.quantity = quantities
    if @school.valid?
      ## Unfortunately this isn't dynamic, but its coming in a future release.
      ## MARK: willfix
       @school.ou_string = params[:school][:student_ou]
       @school.teacher_ou = params[:school][:teacher_ou]
       @school.save
       set_flash('School created successfully')
    else
      set_flash('School could not be created', 'error')
    end
    redirect_to action: 'index'
  end

  private

  def school_params
    params.require(:school).permit(:name, :school_code, :blended_learning, :quantity)
  end
end
