# frozen_string_literal: true

module FlyingHigh
  class FrequentFlyerMember
    attr_accessor :join_date, :initial_points
    attr_reader :id, :name, :status

    def self.new_member
      new('A Frequent Flyer Member', 'Standard')
    end

    def named(name)
      FrequentFlyerMember.new(name, @status)
    end

    def with_status(status)
      FrequentFlyerMember.new(@name, status)
    end

    private

    def initialize(name, status)
      @name = name
      @status = status
      @initial_points = 0
    end
  end
end
