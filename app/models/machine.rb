class Machine < ApplicationRecord
  require 'csv'
  validates :serial_number, uniqueness: {case_sensitive: false}
  validates :client_asset_tag, allow_nil: true, uniqueness: true
  validates :role, presence: true

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

  def assign(school, role_quantity, asset_tag)
    role = role_quantity.role.name
    if location.nil?
      role_quantity.append_quantity
      set_un_boxed
      return update(role: role, location: school, client_asset_tag: asset_tag)
    end
    false
  end
end
