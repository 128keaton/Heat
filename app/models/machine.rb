class Machine < ApplicationRecord
  require 'csv'
  include SpreadsheetArchitect

  validates :serial_number, uniqueness: {case_sensitive: false}
  validates :client_asset_tag, allow_nil: true, uniqueness: true
  validates :role, presence: true

  belongs_to :location, optional: true
  belongs_to :form_factor, optional: true

  def self.to_csv2
    attributes = %w[serial_number client_asset_tag location role]
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |machine|
        csv << attributes.map {|attr| machine.send(attr).upcase}
      end
    end
  end

  def self.receive(params, raw_serial, form_factor)
    machine = new(params)
    machine.form_factor = form_factor
    machine.set_unboxed
    machine.assign_model(raw_serial)
    machine.save!
  end

  def self.parse(serial)
    if serial.include? ','
      serial = CSV.parse(serial.gsub(/\s+/, ''), col_sep: ',')[0][2]
    end
    serial
  end

  def assign_model(raw_serial)
    serial = Machine.parse(raw_serial)
    model_number = Machine.determine_model(raw_serial)
    assign_attributes(serial_number: serial, model: model_number)
  end

  def self.determine_model(raw_serial)
    serial = parse(raw_serial)
    model_number = if raw_serial.include? ','
                     CSV.parse(raw_serial.gsub(/\s+/, ' '), col_sep: ',')[0][0]
                   elsif (model = Model.find_by(first_match: serial[0..2]))
                     model.number
                   else
                     'No Model Found'
                   end
    model_number
  end

  def remove_from_location
    role = Role.find_by(name: self.role)
    return 'Unable to find role' if role.nil?
    role_quantity = RoleQuantity.find_by(role: role, location: location_id)
    return 'Unable to find quantity' if role.nil?
    return 'Unable to update quantity' unless role_quantity.update(quantity: role_quantity.quantity - 1)
    'Machine removed from location' if destroy!
  end

  def can_image?
    imaged.nil?
  end

  def print_label(model = nil)
    location_name = location.name
    asset_tag = client_asset_tag
    type = Role.find_by(name: role).suffix
    image_string = 'Standard Device'
    model = get_model_number if model.nil?

    # TODO: Make this an ENV var
    uri = URI.parse("http://webapps.nationwidesurplus.com/scs/print?image=#{image_string}&asset_number=#{asset_tag}&serial_number=#{serial_number.upcase}&school=#{location_name}&model=#{model}&type=#{type}")

    begin
      response = Net::HTTP.get_response(uri)
    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
        Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError,
        Net::ProtocolError => e
      logger.error e
      return {status: 'error', message: 'Unable to print', error: e}
    end
    {status: 'success', message: 'Printed successfully', response: response}
  end

  def get_model_number
    return 'HP ProBook 430 G5' if model == ''
    model
  end

  def mark_doa(reason)
    update(doa: reason, unboxed: nil, imaged: nil, racked: nil, deployed: nil, location: nil, rack: nil)
  end

  def set_unboxed
    update(unboxed: {date: Time.zone.now.strftime('%d/%m/%Y %H:%M')})
    self
  end

  def set_imaged
    update(imaged: {date: Time.zone.now.strftime('%d/%m/%Y %H:%M')})
  end

  def self.get_machine(serial_number, role)
    unless (machine = Machine.find_by(serial_number: serial_number))
      return nil unless Role.exists? role
      machine = Machine.new
      machine.serial_number = serial_number
      machine.role = Role.find(role)
      machine.save!
    end
    machine
  end

  def hostname
    return 'No location' if location_id.nil?
    return 'No role' if role.nil?
    school = Location.find(location_id)
    return 'No School' if school.nil?
    role_suffix = Role.find_by(name: role).suffix
    return 'No suffix' if role_suffix.nil?

    device_type = 'LT'
    device_type = form_factor.type unless form_factor.nil?
    device_type = 'BL' if school.blended_learning

    hostname = "#{school.school_code}#{role_suffix}#{device_type}-"
    remaining_chars = 15 - hostname.length
    hostname << serial_number.split(//).last(remaining_chars).join
    hostname
  end

  def assign(location, role_quantity, asset_tag)
    role = role_quantity.role.name
    unless location.nil?
      set_unboxed
      if update(role: role, location_id: location.id, client_asset_tag: asset_tag)
        role_quantity.append_quantity
        return save!
      end
      false
    end
    false
  end

  def spreadsheet_columns
    [['Serial Number', :serial_number],
     ['Model', :model],
     ['Asset Tag', :client_asset_tag],
     ['Location', location.name],
     ['Inventory Location', (inventory_location ? inventory_location : 'Not placed in inventory')],
     ['Role', :role]]
  end

  def self.by_date
    Machine.where.not(imaged: nil)
  end
end
