class FormFactorController < ApplicationController
  def create
    if FormFactor.create(form_factor_params)
      set_flash('Created form factor')
    else
      set_flash('Unable to create form factor', 'error')
    end

    redirect_to action: index
  end

  def edit
    @form_factor = FormFactor.find(params[:id])
  end

  def update
    form_factor = FormFactor.find(params[:id])
    if form_factor&.update(form_factor_params)
      set_flash('Updated form factor')
    else
      set_flash('Unable to update form factor', 'error')
    end
    redirect_to action: index
  end

  def index; end

  private

  def set_flash(notice, type = 'success')
    flash[:notice] = notice
    flash[:type] = type
  end

  def form_factor_params
    params.require(:form_factor).permit(:name, :type)
  end
end
