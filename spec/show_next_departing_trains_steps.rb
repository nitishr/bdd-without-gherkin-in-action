require 'time'
require 'time_tables'

module ShowNextDepartingTrainsSteps
  extend Turnip::DSL
  include TimeTables

  RSpec.configure do |config|
    config.before do
      @time_table = InMemoryTimeTable.new
      @itinerary_service = ItineraryService.new(@time_table)
    end
  end

  step 'the :line train to :to leaves :from at :departure_times' do |line, to, from, departure_times|
    @time_table.schedule_service(line, departure_times, from, to)
  end

  step 'Travis want to travel from :from to :to at :departure_time' do |from, to, departure_time|
    @proposed_departures = @itinerary_service.find_next_departures(departure_time, from, to)
  end

  step 'he should be told about the trains at: :departure_times' do |departure_times|
    expect(@proposed_departures).to eq departure_times
  end

  placeholder :departure_times do
    match /.*/ do |times|
      times.split(',').map(&:strip).map { |time| Time.parse(time) }
    end
  end

  placeholder(:departure_time) { match(/.*/) { |time| Time.parse(time) } }
end
