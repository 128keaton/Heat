class ModelsController < ApplicationController
  def create
    if Model.create(model_params)
      set_flash('Created model')
    else
      set_flash('Unable to create model', 'error')
    end

    redirect_to action: index
  end

  def edit
    @model = Model.find(params[:id])
  end

  def update
    model = Model.find(params[:id])
    if model&.update(model_params)
      set_flash('Updated model')
    else
      set_flash('Unable to update model', 'error')
    end
    redirect_to action: index
  end

  def destroy
    model = Model.find(params[:id])
    if model&.destroy
      set_flash('Removed model')
    else
      set_flash('Unable to remove model', 'error')
    end
    redirect_to action: index
  end

  def index; end

  private

  def set_flash(notice, type = 'success')
    flash[:notice] = notice
    flash[:type] = type
  end

  def model_params
    params.require(:model).permit(:first_match, :number)
  end
end
