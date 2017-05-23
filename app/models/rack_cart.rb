class RackCart < ApplicationRecord
    serialize :children,Array
    def label
        "#{rack_id} #{location}"
    end
end
