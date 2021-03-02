# frozen_string_literal: true

module FlyingHigh
  class RecordedFlight
    attr_reader :date, :member, :departure, :destination, :cabin_class, :is_delayed, :delay, :points_earned

    def initialize(date, member, departure, destination, cabin_class, is_delayed, delay, points_earned)
      @date = date
      @member = member
      @departure = departure
      @destination = destination
      @cabin_class = cabin_class
      @is_delayed = is_delayed
      @delay = delay
      @points_earned = points_earned
    end
  end
end
