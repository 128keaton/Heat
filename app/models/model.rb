class Model < ApplicationRecord
  validates :number, uniqueness: true, presence: true
  validates :first_match, presence: true, uniqueness: true
end
