class RackCart < ApplicationRecord
    serialize :children,Array
end
