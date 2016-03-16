class Route < ApplicationRecord
    has_many :route_transports

    validates_presence_of :start
    validates_presence_of :end

    def to_json
      return to_h.to_json
    end

    def to_h
      return {

              start: JSON.parse(self.full_start),
              end: JSON.parse(self.full_end),
              transports: JSON.parse(self.cache)
            }

    end
end
