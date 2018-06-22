class RootController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def mark_doa
    serial_number = params[:machine][:serial_number]
    if (machine = Machine.find_by(serial_number: serial_number))
      machine.mark_doa(params[:machine][:doa])
      set_flash('Machine was marked as DOA')
    else
      set_flash('Machine not found', 'error')
    end
    redirect_to action: 'index'
  end

  def set_flash(notice, type = 'success')
    flash[:notice] = notice
    flash[:type] = type
  end


  def import;
  end

  def process_file
    uploaded_io = params[:import][:file]
    file_name = "imported-data-#{Time.zone.now}.xlsx".delete(' ')
    file_path = Rails.root.join('public', 'uploads', file_name)
    File.open(file_path, 'wb') do |file|
      file.write(uploaded_io.read)
    end

    xlsx = Roo::Spreadsheet.open("#{file_path}")
    sheet = xlsx.sheet(0)
    school_quantities = []
    loose_quantities = []

    sheet.each(quantity: 'Quantity', type: 'Product', location: 'School Name', contact: 'Deliver To Contact') do |row|
      unless not_int?(row[:quantity]) || row[:location].nil?
        if School.location_is_school(row[:location].to_s) && row[:location] != 'School Name'
          school_quantities.push(row)
        elsif !School.location_is_school(row[:location].to_s) && row[:location] != 'School Name'
          loose_quantities.push(row)
        end
      end
    end

    render json: { loose: loose_quantities, school: school_quantities }
  end

  private

  def not_int?(prop)
    unless prop.nil?
      begin
        Integer(prop)
      rescue ArgumentError
        true
      end
      return false
    end
    true
  end
end

