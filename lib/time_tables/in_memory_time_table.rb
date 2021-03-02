# frozen_string_literal: true

module TimeTables
  class UnknownLineException < StandardError; end

  class InMemoryTimeTable
    def initialize
      @schedules = {}
    end

    def schedule_service(line, departing_at, from, to)
      @schedules[line] = ScheduledService.new(from, to, departing_at)
    end

    def find_lines_through(from, to)
      @schedules.keys.select { |line| @schedules.fetch(line, ScheduledService::NO_SERVICE).goes_between?(from, to) }
    end

    def departures(line_name, _from)
      schedule = @schedules[line_name]
      raise UnknownLineException, "No line found: #{line_name}" unless schedule

      schedule.departure_times
    end
  end
end
