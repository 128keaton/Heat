class RoleQuantity < ApplicationRecord
  belongs_to :role
  belongs_to :location

  after_save { |role_quantity| role_quantity.destroy if role_quantity.role_id.blank? }
  after_save { |role_quantity| role_quantity.destroy if role_quantity.location_id.blank? }
  after_initialize :init

  def init
    self.max_quantity ||= 0
    self.quantity ||= 0
  end

  def get_role
    return Role.find(role_id) if Role.exists? role_id
    location.role_quantities.delete(self)
    destroy!
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
