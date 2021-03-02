module FlyingHigh
  class FrequentFlyerMemberRepository
    def initialize
      @frequent_flyer_members = []
    end

    def save(frequent_flyer_member)
      @frequent_flyer_members << frequent_flyer_member
      frequent_flyer_member
    end

    def find_by_name(name)
      @frequent_flyer_members.find { |frequent_flyer_member| frequent_flyer_member.name == name }
    end
  end
end
