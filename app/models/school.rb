class School < ApplicationRecord
  validates :school_code, uniqueness: true
  validate :blank_but_not_nil
  validates :school_code, presence: true


  def blank_but_not_nil
    if self.quantity.nil?
      errors.add :quantity, 'cannot be nil'
    end
  end

  def render_machines(format = 'json')
    if format == 'json'
      {status: 'success', machines: Machine.where(location: name)}.to_json
    else
      Machine.where(location: name).to_csv(true)
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
end
