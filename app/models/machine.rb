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

  def print_label
    location_name = location.name
    asset_tag = client_asset_tag
    type = Role.find_by(name: role).suffix
    image_string = 'Standard Device'

    # TODO: Make this an ENV var
    uri = URI.parse("http://webapps.nationwidesurplus.com/scs/print?image=#{image_string}&asset_number=#{asset_tag}&serial_number=#{serial_number.upcase}&school=#{location_name}&model=#{get_model_number}&type=#{type}")

    begin
      response = Net::HTTP.get_response(uri)
    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
        Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError,
        Net::ProtocolError => e
      logger.error e
      return { status: 'error', message: 'Unable to print', error: e}
    end
    {status: 'success', message: 'Printed successfully', response: response}
  end

  # TODO: Make this non-hardcoded
  def get_model_number
    'HP ProBook 430 G5'
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
      role_quantity.append_quantity
      set_unboxed
      return update(role: role, location_id: location.id, client_asset_tag: asset_tag)
    end
    false
  end

  def spreadsheet_columns
    [['Serial Number', :serial_number],
     ['Asset Tag', :client_asset_tag],
     ['Inventory Location', :inventory_location],
     ['Role', :role]]
  end

  def self.by_date
    Machine.where.not(imaged: nil)
  end
end
