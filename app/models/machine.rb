class Machine < ApplicationRecord
    validates :serial_number, uniqueness: true
    validates :role, presence: true
end
