module FlyingHigh
  class PointsMultiplierRepository
    def initialize
      @points_multipliers = []
    end

    def delete_all
      @points_multipliers.clear
    end

    def save(points_multiplier)
      @points_multipliers << points_multiplier
      points_multiplier
    end

    def find_by_status(status)
      @points_multipliers.find { |multiplier| multiplier.status == status }
    end
  end
end
