class Machine < ApplicationRecord
    validates :serial_number, uniqueness: {case_sensitive: false}
    validates :role, presence: true
end
