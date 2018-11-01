class Model < ApplicationRecord
  validates :number, presence: true
  validates :first_match, presence: true, uniqueness: true
end
