class SchoolsController < ApplicationController
  before_action :authenticate_user!
  def index
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

  def create
     @school = School.new(school_params)
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
