class RoleQuantity < ApplicationRecord
  belongs_to :role
  belongs_to :location

  def get_role
    Role.find(role_id)
  end

  def get_school
    Location.find(school_id)
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

  def self.update(role_quantity, passed_role)
    Rails.logger.info "Role ID2 #{passed_role}"
    if passed_role[:id].empty? || passed_role[:id].nil?
      role_quantity.destroy
      Rails.logger.info "fuck"
      return nil
    end
    role_quantity.max_quantity = passed_role[:max_quantity]
    role_quantity.ou = passed_role[:ou]
    role_quantity.save!
    role_quantity
  end
end
