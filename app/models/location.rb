class Location < ApplicationRecord
  validates :school_code, uniqueness: true
  validates :school_code, presence: true
  logger = Rails.logger

  has_many :role_quantities
  has_many :roles, :through => :role_quantities
  has_many :machines

  def render_machines(format = 'json')
    if format == 'json'
      {status: 'success', machines: Machine.where(location: name)}.to_json
    else
      Machine.where(location: name).to_csv(false)
    end
  end

  def set_school_code(code)
    return if code.nil?
    update(school_code: code)
  end

  def add_roles(roles)
    if roles&.each do |role_id, passed_role|
      role_quantity = setup_role_quantity(passed_role)
      unless role_quantity.nil?
        logger.info "Role-Passed: #{passed_role}"
        add_role_quantity(role_quantity)
        true
      end
    end
    end
    false
  end

  def self.location_is_school(location)
    loc_string = location.downcase

    unless loc_string == '@location name' || loc_string.nil?
      return (loc_string.include? '@location') || (loc_string.include? 'academy') ||
          (loc_string.include? 'high') || (loc_string.include? 'middle') ||
          (loc_string.include? 'elementary')
    end
    false
  end

  def self.search_by(id, name, code)
    if id
      location = Location.find(id)
    elsif name
      location = Location.where('name ILIKE :name', name: name.to_s)
    elsif code
      location = Location.where(school_code: code)
    else
      return 'No ID or search parameter found'
    end
    location
  end

  def find_ou_for_role(role)
    return if role.nil?

    if (!role.is_a? Role) && (!role.is_a? String)
      role = Role.find(role)
    elsif role.is_a? String
      role = Role.find_by(name: role)
    end

    role_quantities.find_by(role: role).ou
  end

  private

  def add_role_quantity(role_quantity)
    role_quantities.append(role_quantity)
    role_quantity.save!
  end

  def setup_role_quantity(passed_role)
    quantity = passed_role[:max_quantity].to_i
    ou = passed_role[:ou]

    logger.info "Quantity2: #{passed_role}"
    return nil unless (role_quantity = find_or_setup(passed_role))
    role_quantity.max_quantity = quantity
    role_quantity.ou = ou

    return nil if passed_role[:id].empty?
    role = Role.find(passed_role[:id].to_i)
    role_quantity.role = role


    role_quantity
  end

  def find_or_setup(passed_role)
    return RoleQuantity.new unless (role_quantity_id = passed_role[:role_quantity_id])
    if RoleQuantity.exists?(id: role_quantity_id) && passed_role[:max_quantity]
      role = RoleQuantity.find(role_quantity_id)
      RoleQuantity.update(role, passed_role)
    elsif RoleQuantity.exists?(id: role_quantity_id) && passed_role[:id].empty? && passed_role[:max_quantity].nil?
      RoleQuantity.find(role_quantity_id).destroy
    elsif !passed_role.nil? && passed_role[:max_quantity]
      RoleQuantity.new
    end
    nil
  end

end
