class School < ApplicationRecord
        validates :school_code, uniqueness: true
        validate :blank_but_not_nil
        validates :school_code, presence: true


        def blank_but_not_nil
                if self.quantity.nil?
                        errors.add :quantity, 'cannot be nil'
                end
        end
end
