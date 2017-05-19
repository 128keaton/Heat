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
    @school = School.find(params[:id])
    @school.destroy
    flash[:notice] = "School deleted successfully"
    flash[:type] = "success"
    redirect_to action: 'index'
  end

  def update
     @school = School.where(school_code: params[:school][:school_code])[0]
     if @school == nil
        @school = School.where(name: params[:name])[0]
     end
     if params[:school][:school_code]
      @school.school_code = params[:school][:school_code]
     end


     quantities = {}
     Role.all.each do |role|
      quantities[role.name] = params["#{role.name}-role"]
     end

     @school.quantity = quantities
    if @school.valid?
       @school.save
       flash[:notice] = "School updated successfully"
       flash[:type] = "success"
       redirect_to action: 'index'
    else
      flash[:notice] = "School could not be updated"
      flash[:type] = "error"
      redirect_to action: 'index'
    end
  end

  def edit
    @school = School.find(params[:id])
    @roles = Role.all
    if flash[:notice]
      @type = params[:type]
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
