class Role < ApplicationRecord
  has_many :role_quantities
  has_many :quantities, through: :role_quantities

  def in?(location)
    return if role_quantities.empty?
    return if role_quantities.nil?
    role_quantities.each do |rq|
      rq.location == location
    end
  end
end
