module ScheduleAttribute
  class Conversions
    def self.to_day(value)
      return value if value.to_i == value
      return Constants::VALUE_HASH[:day][value] unless Constants::VALUE_HASH[:day][value].blank?
      return 0
    end

    def self.to_hour(value)
      return value.to_i
    end

    def self.to_minute(value)
      return value.to_i
    end

    def self.to_second(value)
      return value.to_i
    end
  end
end
