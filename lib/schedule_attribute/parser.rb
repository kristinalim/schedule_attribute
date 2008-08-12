module ScheduleAttribute
  class Parser
    def self.parse_schedule(type, value)
      value = String.new(value)
      schedules = []

      while (line = value.slice!(/\A[\r\n]*[^\r\n]+[\r\n]*/))
        line = ActiveSupport::Multibyte::Handlers::UTF8Handler.strip(line)
        start_time, end_time = [nil, nil]

        unless line.to_s =~ Constants::FORMAT_EXPRESSIONS[type]
          return schedules
        else
          start_time = parse_time(type, line)
        end

        line = value.slice!(/\A[^\r\n]+[\r\n]*/)
        unless line =~ Constants::FORMAT_EXPRESSIONS[type]
          return schedules
        else
          end_time = parse_time(type, line)
        end
        schedules << [start_time, end_time]
      end
      schedules
    end

    def self.parse_time(type, value)
      value_hash = {}

      case type
      when :weekly:
        matches = value.scan(Constants::FORMAT_EXPRESSIONS[type])
        break if matches.blank?
        matches = matches.first
        value_hash[:days] = Conversions.to_day(matches.shift)
        value_hash[:hours] = Conversions.to_hour(matches.shift)
        value_hash[:minutes] = Conversions.to_minute(matches.shift)
      end

      value_hash
    end

    def self.schedule_within_day(type, value, day)
      schedules = parse_schedule(type, value)
      schedules.each { |schedule| result = (schedule[0][:days] == day && schedule[0][:days] == schedule[1][:days]) ; return [schedule[0], schedule[1]] if result }

      return nil
    end
  end
end
