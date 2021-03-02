# frozen_string_literal: true

module FlyingHigh
  class PointsMultiplier
    attr_reader :id, :status, :multiplier

    def self.for_status(status)
      PointsMultiplierBuilder.new(status)
    end

    private

    def initialize(status, multiplier)
      @status = status
      @multiplier = multiplier
    end

    STANDARD_MULTIPLIER = new(:standard, 1.0)
  end

  class PointsMultiplierBuilder
    def initialize(status)
      @status = status
    end

    def is(multiplier)
      PointsMultiplier.new(@status, multiplier)
    end
  end
end
