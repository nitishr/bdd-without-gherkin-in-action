# frozen_string_literal: true

module FlyingHigh
  class PointsSchedule
    attr_reader :id, :departure, :destination, :cabin_class, :points

    def initialize(departure, destination, cabin_class, points)
      @departure = departure
      @destination = destination
      @cabin_class = cabin_class
      @points = points
    end

    def self.from(departure)
      PointsScheduleBuilder.new(departure)
    end
  end

  class PointsScheduleBuilder
    def initialize(departure)
      @departure = departure
    end

    def to(destination)
      @destination = destination
      self
    end

    def in(destination)
      @destination = destination
      self
    end

    def flying_in(cabin_class)
      @cabin_class = cabin_class
      self
    end

    def earns(points)
      PointsSchedule.new(@departure, @destination, @cabin_class, points)
    end
  end
end
