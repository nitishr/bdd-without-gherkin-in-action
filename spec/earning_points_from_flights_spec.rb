# frozen_string_literal: true

require 'flying_high'

module FlyingHigh
  RSpec.describe 'Earning Frequent Flyer points from flights' do
    before do
      @points_schedule_repository = PointsScheduleRepository.new
      @points_multiplier_repository = PointsMultiplierRepository.new
      @frequent_flyer_member_repository = FrequentFlyerMemberRepository.new
      @recorded_flight_repository = RecordedFlightRepository.new
      @frequent_flyer_points_service = FrequentFlyerPointsService.new(
        @frequent_flyer_member_repository, @points_multiplier_repository,
        @points_schedule_repository, @recorded_flight_repository
      )
      @past_flight_eligibility_service = PastFlightEligibilityService.new
    end

    before do
      scheduled_points(from: 'London', to: 'New York',
                       are: { 'Economy' => 550, 'Business' => 800, 'First' => 1650 })
      scheduled_points(from: 'New York', to: 'Los Angeles',
                       are: { 'Economy' => 100, 'Business' => 140, 'First' => 200 })

      points_multiplier_for(status: 'Standard', is: 1.0)
      points_multiplier_for(status: 'Silver', is: 1.5)
      points_multiplier_for(status: 'Gold', is: 2.0)
    end

    specify 'travellers earn points depending on the points schedule' do
      expect(points_earned_with(status: 'Standard', from: 'London', to: 'New York', in_cabin_class: 'Economy'))
        .to eq 550
    end

    describe 'travellers earn more points in higher cabin classes' do
      specify do
        expect(points_earned_with(status: 'Silver', from: 'London', to: 'New York', in_cabin_class: 'Economy'))
          .to eq 825
      end
      specify do
        expect(points_earned_with(status: 'Silver', from: 'New York', to: 'Los Angeles', in_cabin_class: 'Business'))
          .to eq 210
      end
      specify do
        expect(points_earned_with(status: 'Silver', from: 'New York', to: 'London', in_cabin_class: 'First')).to eq 2475
      end
    end

    describe 'higher frequent flyer status levels earn more points' do
      specify do
        expect(points_earned_with(status: 'Standard', from: 'London', to: 'New York', in_cabin_class: 'Business'))
          .to eq 800
      end
      specify do
        expect(points_earned_with(status: 'Silver', from: 'New York', to: 'Los Angeles', in_cabin_class: 'Business'))
          .to eq 210
      end
      specify do
        expect(points_earned_with(status: 'Gold', from: 'New York', to: 'London', in_cabin_class: 'Business'))
          .to eq 1600
      end
    end

    specify '50% bonus points for members who already have 10000 points' do
      silver_member_with_20k_points = FrequentFlyerMember.new_member.with_status('Silver')
      silver_member_with_20k_points.initial_points = 20_000
      expect(
        points_earned_by(silver_member_with_20k_points, from: 'London', to: 'New York', in_cabin_class: 'Business')
      ).to eq 1800
    end

    specify 'completed flights in the past 90 days can be claimed' do
      member = FrequentFlyerMember.new_member
      member.join_date = Time.new(2020, 1, 1)
      expect(flights_eligible_for(member,
                                  past_flight('FH-101').on(2019, 12, 1).completed,
                                  past_flight('FH-102').on(2019, 12, 1).cancelled,
                                  past_flight('FH-101').on(2019, 8, 1).completed))
        .to match_array [past_flight('FH-101').on(2019, 12, 1).completed]
    end

    def points_multiplier_for(status:, is:)
      @points_multiplier_repository.save(PointsMultiplier.for_status(status).is(is))
    end

    def points_earned_with(status:, from:, to:, in_cabin_class:)
      points_earned_by(
        FrequentFlyerMember.new_member.with_status(status), from: from, to: to, in_cabin_class: in_cabin_class
      )
    end

    def points_earned_by(member, from:, to:, in_cabin_class:)
      @frequent_flyer_points_service.record_flight(member, from, to, in_cabin_class)
      @frequent_flyer_points_service.points_earned_by(member)
    end

    def scheduled_points(from:, to:, are:)
      route = PointsSchedule.from(from).to(to)
      are.each do |cabin_class, points|
        @points_schedule_repository.save(route.flying_in(cabin_class).earns(points))
      end
    end

    def flights_eligible_for(member, *past_flights)
      @past_flight_eligibility_service.flights_eligible_for(member, past_flights)
    end

    def past_flight(flight_number)
      PastFlightBuilder.new(flight_number)
    end
  end

  class PastFlightBuilder
    def initialize(flight_number)
      @flight_number = flight_number
    end

    def on(year, month, day)
      @date = Time.new(year, month, day)
      self
    end

    def completed
      with_status('COMPLETED')
    end

    def cancelled
      with_status('CANCELLED')
    end

    private

    def with_status(status)
      PastFlight.new(@flight_number, @date, status)
    end
  end
end
