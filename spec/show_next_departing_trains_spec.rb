require 'time'
require 'time_tables'
module TimeTables
  RSpec.describe 'Show next departing trains' do
    before do
      @time_table = InMemoryTimeTable.new
      @itinerary_service = ItineraryService.new(@time_table)
    end

    specify 'next trains going to the requested destination on the same line' do
      the_train('T1', to: 'Chatswood', leaves: 'Hornsby', at: %w[08:02 08:15 08:21])
      expect(proposed_times_to_travel(from: 'Hornsby', to: 'Chatswood', at: '08:00')).to eq %w[08:02 08:15]
    end

    specify 'next trains going to the requested destination on different lines' do
      the_train('T1', to: 'Chatswood', leaves: 'Hornsby', at: %w[08:02 08:15 08:21 08:45])
      the_train('T9', to: 'Chatswood', leaves: 'Hornsby', at: %w[08:05 08:12 08:25])
      expect(proposed_times_to_travel(from: 'Hornsby', to: 'Chatswood', at: '08:00')).to eq %w[08:02 08:05]
    end

    def the_train(line, to:, leaves:, at:)
      @time_table.schedule_service(line, at.map { |time| Time.parse(time) }, leaves, to)
    end

    def proposed_times_to_travel(from:, to:, at:)
      @itinerary_service.find_next_departures(Time.parse(at), from, to).map { |time| time.strftime('%H:%M') }
    end
  end
end
