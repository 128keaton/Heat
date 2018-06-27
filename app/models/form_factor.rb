class FormFactor < ApplicationRecord
  has_many :machines

  validates :name, uniqueness: true, presence: true
  validates :type, presence: true, uniqueness: true

  self.inheritance_column = :_type_disabled
end
