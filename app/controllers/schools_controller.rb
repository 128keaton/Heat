class SchoolsController < ApplicationController
  def index
    @school = School.new
     if params[:message]
      @message = params[:message]
      @type = params[:type]
      params.delete :message
      params.delete :type
    end
  end


 def destroy
    @school = School.find(school_code: params[:id][:id])
    @school.destroy
    redirect_to controller: 'schools', action: 'index', message: "School has been deleted.", type: "success"
  end
  def create
     @school = School.new(school_params)
    if @school.valid?
       @school.save
        redirect_to controller: 'schools', action: 'index', message: "School has been added.", type: "success"
    else
        redirect_to controller: 'schools', action: 'index', message: "School already added", type: "error"
    end
  end

  private

  def school_params
    params.require(:school).permit(:name, :school_code, :blended_learning, :quantity)
  end
end
