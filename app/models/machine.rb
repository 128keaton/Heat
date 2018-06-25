class Machine < ApplicationRecord
  require 'csv'
  include SpreadsheetArchitect

  validates :serial_number, uniqueness: {case_sensitive: false}
  validates :client_asset_tag, allow_nil: true, uniqueness: true
  validates :role, presence: true

  belongs_to :location

  def self.to_csv
    attributes = %w[serial_number client_asset_tag location role]
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |machine|
        csv << attributes.map {|attr| machine.send(attr).upcase}
      end
    end
  end

  # TODO: Make this non-hardcoded
  def get_model_number
    'HP ProBook 430 G5'
  end

  def mark_doa(reason)
    update(doa: reason, unboxed: nil, imaged: nil, racked: nil, deployed: nil, location: nil, rack: nil)
  end

  def set_un_boxed
    assign_attributes(unboxed: {date: Time.zone.now.strftime('%d/%m/%Y %H:%M')})
    if valid?
      save
    else
      errors
    end
  end

  def set_imaged
    assign_attributes(imaged: {date: Time.zone.now.strftime('%d/%m/%Y %H:%M')})
    if valid?
      save
    else
      errors
    end
  end

  def self.get_machine(serial_number)
    unless (machine = Machine.find_by(serial_number: serial_number))
      machine = Machine.new
      machine.serial_number = serial_number
      machine.location = params[:sc]
      machine.save!
    end
    machine
  end

  def hostname
    return nil if location.nil?
    return nil if role.nil?
    school = Location.find_by(name: location)
    return nil if school.nil?
    role_suffix = Role.find_by(name: role).suffix
    return nil if role_suffix.nil?

    if school.blended_learning
      "#{school.school_code}#{role_suffix}BL-#{serial_number.split(//).last(7).join}"
    else
      "#{school.school_code}#{role_suffix}LT-#{serial_number.split(//).last(7).join}"
    end
  end

  def assign(location, role_quantity, asset_tag)
    role = role_quantity.role.name
    unless location.nil?
      role_quantity.append_quantity
      set_un_boxed
      return update(role: role, location: location, client_asset_tag: asset_tag)
    end
    false
  end

  def spreadsheet_columns
    [['Serial Number', :serial_number],
     ['Asset Tag', :client_asset_tag],
     ['Location', :location],
     ['Inventory Location', :inventory_location],
     ['Role', :role]]
  end
end
