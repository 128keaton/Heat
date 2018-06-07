class School < ApplicationRecord
  validates :school_code, uniqueness: true
  validate :blank_but_not_nil
  validates :school_code, presence: true


  def blank_but_not_nil
    if self.quantity.nil?
      errors.add :quantity, 'cannot be nil'
    end
  end

  def render_machines
    render json: {status: 'success', message: Machine.where(location: location)}
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
end
