# frozen_string_literal: true
require 'time'

module FlyingHigh
  class PastFlightEligibilityService
    def flights_eligible_for(member, submitted_flights)
      submitted_flights.select do |flight|
        flight.status == 'COMPLETED' && member.join_date - flight.scheduled_date <= 90 * 24 * 60 * 60
      end
    end
  end
end
