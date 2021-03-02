# frozen_string_literal: true
require 'flying_high'

module EarningPointsFromFlightsSteps
  extend Turnip::DSL
  include FlyingHigh

  RSpec.configure do |config|
    config.before do
      @points_schedule_repository = PointsScheduleRepository.new
      @points_multiplier_repository = PointsMultiplierRepository.new
      @frequent_flyer_member_repository = FrequentFlyerMemberRepository.new
      @recorded_flight_repository = RecordedFlightRepository.new
      @frequent_flyer_points_service = FrequentFlyerPointsService.new(
        @frequent_flyer_member_repository, @points_multiplier_repository, @points_schedule_repository, @recorded_flight_repository)
      @past_flight_eligibility_service = PastFlightEligibilityService.new
    end
  end

  step 'the following flight points schedule:' do |table|
    # table is a table.hashes.keys # => [:From, :To, :Class, :Points]
    @points_schedule_repository.delete_all
    table.hashes.each do |hash|
      @points_schedule_repository.save(
        PointsSchedule.from(hash['From']).to(hash['To']).flying_in(hash['Class']).earns(hash['Points'].to_i)
      )
    end
  end

  step 'the following flyer types multipliers:' do |table|
    # table is a table.hashes.keys # => [:Status, :Multiplier]
    @points_multiplier_repository.delete_all
    table.hashes.each do |hash|
      @points_multiplier_repository.save(
        PointsMultiplier.for_status(hash['Status']).is(hash['Multiplier'].to_f)
      )
    end
  end

  step ':name is a :status Frequent Flyer member' do |name, status|
    @member = @frequent_flyer_member_repository.save(FrequentFlyerMember.new_member.named(name).with_status(status))
  end

  step '(s)he flies from :departure to :destination in :cabin_class class' do |departure, destination, cabin_class|
    @frequent_flyer_points_service.record_flight(@member, departure, destination, cabin_class)
  end

  step '(s)he should earn :points points' do |points|
    expect(@frequent_flyer_points_service.points_earned_by(@member)).to eq points.to_f
  end

  step 'the distance from :departure to :destination is :distance km' do |departure, destination, distance|
  end

  step '(s)he has been a member for :years years' do |years|
    @member.join_date = Time.new(Time.now.year - years.to_i)
  end

  step '(s)he views her award trips' do
  end

  step 'the available destinations should be :destinations' do
  end

  step ':name is a :status Frequent Flyer member with :points points' do |name, status, points|
    @member = @frequent_flyer_member_repository.save(FrequentFlyerMember.new_member.named(name).with_status(status))
    @member.initial_points = points.to_i
    @frequent_flyer_member_repository.save(@member)
  end

  step ':member joined the Frequent Flyer programme on :join_date' do |member, join_date|
    @member = FrequentFlyerMember.new_member.named(member)
    @member.join_date = Time.parse(join_date)
    @frequent_flyer_member_repository.save(@member)
  end

  step '(s)he asks for the following flight to be credited to his account:' do |table|
    # table is a table.hashes.keys # => [:Flight Number, :Date, :Status]
    @eligible_flights = @past_flight_eligibility_service.flights_eligible_for(@member, past_flights(table))
  end

  step 'only the following flights should be credited:' do |table|
    # table is a table.hashes.keys # => [:Flight Number, :Date, :Status]
    expect(@eligible_flights).to match_array(past_flights(table))
  end

  step ':member has travelled on the following flight:' do |member, table|
    # table is a table.hashes.keys # => [:From, :To, :Delayed, :Delayed By, :Extra Points]
    @member = @frequent_flyer_member_repository.save(FrequentFlyerMember.new_member.named(member))
  end

  step 'the flight is credited to her account' do
  end

  step 'she should be credited with :points additional points' do |_points|
  end

  def past_flights(table)
    table.hashes.map do |hash|
      PastFlight.new(hash['Flight Number'], Time.parse(hash['Date']), hash['Status'])
    end
  end

  placeholder(:departure) { match(/.*/) { |departure| departure } }
  placeholder(:destination) { match(/.*/) { |destination| destination } }
end
