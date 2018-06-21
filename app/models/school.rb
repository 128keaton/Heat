class School < ApplicationRecord
  validates :school_code, uniqueness: true
  validates :school_code, presence: true

  has_many :role_quantities
  has_many :roles, :through => :role_quantities

  def render_machines(format = 'json')
    if format == 'json'
      {status: 'success', machines: Machine.where(location: name)}.to_json
    else
      Machine.where(location: name).to_csv(false)
    end
  end

  def set_school_code(code)
    return if code.nil?
    school_code = code
  end

  def add_roles(roles)
    roles.each_value do |passed_role|
      role_quantity = setup_role_quantity(passed_role)
      add_role_quantity(role_quantity)
    end
  end

  def self.search_by(id, name, code)
    if id
      location = School.find(id)
    elsif name
      location = School.where('name ILIKE :name', name: "#{name}")
    elsif code
      location = School.where(school_code: code)
    else
      return 'No ID or search parameter found'
    end
    location
  end

  def find_ou_for_role(role)
    return if role.nil?

    unless role.is_a? Role
      role = Role.find(role)
    end

    role_quantities.where(role: role).ou
  end

  private

  def add_role_quantity(role_quantity)
    role_quantities.append(role_quantity)
    role_quantity.save!
  end

  def setup_role_quantity(passed_role)
    quantity = passed_role[:quantity].to_i
    ou = passed_role[:ou]

    role_quantity = find_or_setup(passed_role)
    role_quantity.max_quantity = quantity
    role_quantity.ou = ou

    if passed_role[:id]
      role = Role.find(passed_role[:id].to_i)
      role_quantity.role = role
    end

    role_quantity
  end

  def find_or_setup(passed_role)
    role_quantity = RoleQuantity.new
    if (role_quantity_id = passed_role[:role_quantity_id])
      if (previous_role_quantity = RoleQuantity.find(role_quantity_id))
        role_quantity = previous_role_quantity
      end
    end
    role_quantity
  end

end
