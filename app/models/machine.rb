class Machine < ApplicationRecord
  require 'csv'
  validates :serial_number, uniqueness: {case_sensitive: false}
  validates :client_asset_tag, allow_nil: true, uniqueness: true
  validates :role, presence: true

  def self.to_csv(show_id = false)
    attributes = %w[serial_number client_asset_tag location role]
    if show_id
      attributes.push('id')
    end

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

  def set_unboxed(user)
    current_date = Time.now.strftime("%d/%m/%Y %H:%M")
    assign_attributes(unboxed: {date: current_date, user: user.name})
    if valid?
      save
    else
      errors
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
