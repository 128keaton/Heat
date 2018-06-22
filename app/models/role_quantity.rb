class RoleQuantity < ApplicationRecord
  belongs_to :role
  belongs_to :school

  def get_role
    Role.find(role_id)
  end

  def get_school
    School.find(school_id)
  end

  def append_quantity(amount = 1)
    new_quantity = quantity + amount
    update(quantity: new_quantity)
  end

  def self.get_role(id)
    if (role_quantity = RoleQuantity.find(id)) && !role_quantity.nil?
      role_quantity.role
    end
  end
end
