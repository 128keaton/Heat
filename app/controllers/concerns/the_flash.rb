# app/controllers/concerns/the_flash.rb
module TheFlash
  extend ActiveSupport::Concern

  def set_flash(notice, type = 'success')
    flash[:notice] = notice
    flash[:type] = type
  end

end