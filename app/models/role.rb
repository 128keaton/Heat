class Role < ApplicationRecord
  has_many :role_quantities
  has_many :quantities, through: :role_quantities
  before_destroy :destroy_role_quantities

  def in?(location)
    location = Location.find(location)
    return false if location.role_quantities.empty?
    return false if location.role_quantities.nil?
    location.role_quantities.exists?(role: self)
  end

  def destroy_role_quantities
    role_quantities.destroy_all
  end
end
