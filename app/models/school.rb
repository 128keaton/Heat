class School < ApplicationRecord
        validates :school_code, uniqueness: true
end
