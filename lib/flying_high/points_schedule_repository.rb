module FlyingHigh
  class PointsScheduleRepository
    def initialize
      @points_schedules = []
    end

    def delete_all
      @points_schedules.clear
    end

    def save(points_schedule)
      @points_schedules << points_schedule
      points_schedule
    end

    def find_points_schedule(departure, destination, cabin_class)
      @points_schedules.select do |schedule|
        schedule.departure == departure && schedule.destination == destination && schedule.cabin_class == cabin_class
      end
    end
  end
end
