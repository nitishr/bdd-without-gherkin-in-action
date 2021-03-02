module TimeTables
  class ScheduledService
    attr_reader :departure_times

    def initialize(from, to, at)
      @departure = from
      @destination = to
      @departure_times = at
    end

    NO_SERVICE = new('', '', [])

    def goes_between?(from, to)
      @departure == from && @destination == to
    end
  end
end
