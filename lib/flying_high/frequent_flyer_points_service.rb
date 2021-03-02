# frozen_string_literal: true
require 'time'

module FlyingHigh
  class FrequentFlyerPointsService
    def initialize(frequent_flyers, points_multiplier_repository, points_schedule_repository, recorded_flight_repository)
      @frequent_flyers = frequent_flyers
      @points_multiplier_repository = points_multiplier_repository
      @points_schedule_repository = points_schedule_repository
      @recorded_flight_repository = recorded_flight_repository
    end

    def record_flight(member, departure, destination, cabin_class)
      schedule = points_schedule_between(departure, destination, cabin_class)
      if schedule
        @recorded_flight_repository.save(RecordedFlight.new(
          Time.now, member, departure, destination, cabin_class, false, 0,
          (schedule.points * multiplier_for(member) * loyalty_bonus_for(member)).to_i))
      end
    end

    def credit_past_flight(frequent_flyer_member, past_flight); end

    def points_earned_by(member)
      @recorded_flight_repository.find_by_member(member).sum(&:points_earned)
    end

    private

    def points_schedule_between(departure, destination, cabin_class)
      @points_schedule_repository.find_points_schedule(departure, destination, cabin_class).first ||
        @points_schedule_repository.find_points_schedule(destination, departure, cabin_class).first
    end

    def multiplier_for(member)
      (@points_multiplier_repository.find_by_status(member.status) || PointsMultiplier::STANDARD_MULTIPLIER).multiplier
    end

    def loyalty_bonus_for(member)
      member.initial_points >= 10_000 ? 1.5 : 1
    end
  end
end
