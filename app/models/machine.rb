class Machine < ApplicationRecord
  require 'csv'
  validates :serial_number, uniqueness: {case_sensitive: false}
  validates :client_asset_tag, allow_nil: true, uniqueness: true
  validates :role, presence: true

  def self.to_csv
    attributes = %w{serial_number client_asset_tag location role}

    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |machine|
        csv << attributes.map {|attr| machine.send(attr).upcase}
      end
    end
  end

  def set_imaged
    assign_attributes(imaged: {"date" => Time.now.strftime("%d/%m/%Y %H:%M"), "imaged" => true})
    if valid?
      save
    else
      errors
    end
  end
end
