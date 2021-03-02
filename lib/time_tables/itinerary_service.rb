module TimeTables
  class ItineraryService
    def initialize(time_table)
      @time_table = time_table
    end

    def find_next_departures(departure_time, from, to)
      @time_table.find_lines_through(from, to)
                 .flat_map { |line| @time_table.departures(line, from) }
                 .select { |train_time| train_time >= departure_time }
                 .sort.take(2)
    end
  end
end
