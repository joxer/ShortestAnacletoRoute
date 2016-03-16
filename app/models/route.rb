class Route < ApplicationRecord
    has_many :route_transports

    validates_presence_of :start
    validates_presence_of :end

    def to_json
      return {start: JSON.parse(self.full_start),
              end: JSON.parse(self.full_end),
              transports: JSON.parse(self.cache)
             }.to_json
    end
end
