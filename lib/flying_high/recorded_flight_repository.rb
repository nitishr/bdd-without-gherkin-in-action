module FlyingHigh
  class RecordedFlightRepository
    def initialize
      @recorded_flights = []
    end

    def save(recorded_flight)
      @recorded_flights << recorded_flight
      recorded_flight
    end

    def find_by_member(member)
      @recorded_flights.select { |recorded_flight| recorded_flight.member.name == member.name }
    end
  end
end
