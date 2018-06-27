class Role < ApplicationRecord
  has_many :role_quantities
  has_many :quantities, through: :role_quantities
  before_destroy :destroy_role_quantities

  def in?(location)
    return false if role_quantities.empty?
    return false if role_quantities.nil?
    location.role_quantities.each do |rq|
      return rq.role_id == id
    end
  end

  def destroy_role_quantities
    role_quantities.destroy_all
  end
end
