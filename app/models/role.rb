class Role < ApplicationRecord
    validates :pallet_count, presence: true
    validates :pallet_layer_count, presence: true

    has_many :role_quantities
    has_many :quantities, :through => :role_quantities
end
