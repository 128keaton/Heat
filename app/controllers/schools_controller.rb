class SchoolsController < ApplicationController
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
    redirect_to controller: 'schools', action: 'index', type: "success"
  end

  def create
     @school = School.new(school_params)
    if @school.valid?
       @school.save
       flash[:notice] = "School created successfully"
       redirect_to controller: 'schools', action: 'index', type: "success"
    else
      flash[:notice] = "School could not be created"
      redirect_to controller: 'schools', action: 'index', type: "error"
    end
  end

  private

  def school_params
    params.require(:school).permit(:name, :school_code, :blended_learning, :quantity)
  end
end
