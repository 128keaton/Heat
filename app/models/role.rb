class Role < ApplicationRecord
    validates :pallet_count, presence: true
    validates :pallet_layer_count, presence: true
end
