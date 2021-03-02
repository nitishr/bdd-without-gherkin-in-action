# frozen_string_literal: true

module FlyingHigh
  PastFlight = Struct.new(:flight_number, :scheduled_date, :status, :was_delayed, :delayed_by) do
    def eql?(other)
      flight_number == other.flight_number && scheduled_date == other.scheduled_date
    end

    def hash
      [flight_number, scheduled_date].hash
    end
  end
end
