module ScheduleAttribute
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def schedule_attribute(*attributes)
      validates_as_schedule_attribute *attributes
      include ScheduleAttribute::InstanceMethods
    end
  end

  module InstanceMethods
    def within_schedule?(type, attribute, time = Time.now.utc)
      value = send(attribute)

      case type
      when :weekly:
        schedules = parse_schedule(type, value)
        schedules.each { |schedule| result = within?(schedule[0], schedule[1], time_to_hash(type, time)) ; return true if result }
      end

      return false
    end

    private

    def within?(start_time, end_time, current_time)
      (accummulate_time(start_time) <= accummulate_time(current_time) && accummulate_time(current_time) <= accummulate_time(end_time)) ||
          (accummulate_time(end_time) <= accummulate_time(start_time) && accummulate_time(start_time) <= accummulate_time(current_time)) ||
          (accummulate_time(end_time) <= accummulate_time(start_time) && accummulate_time(end_time) >= accummulate_time(current_time))
    end

    def time_to_hash(type, time)
      value_hash = {}

      case type
      when :weekly:
        value_hash[:days] = time.wday
        value_hash[:hours] = time.hour
        value_hash[:minutes] = time.min
      end

      value_hash
    end

    def parse_time(type, value)
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

    def accummulate_time(value_hash)
      value = 0
      value += value_hash[:seconds].to_i * 1.second.to_i
      value += value_hash[:minutes].to_i * 1.minute.to_i
      value += value_hash[:hours].to_i   * 1.hour.to_i
      value += value_hash[:days].to_i     * 1.day.to_i
      value += value_hash[:weeks].to_i    * 1.week.to_i
      value += value_hash[:months].to_i   * 1.month.to_i

      value
    end

    def read_schedule?(type, attribute)
      value = send(attribute)
      parse_schedule(type, value)
    end

    def parse_schedule(type, value)
      value = String.new(value)
      schedules = []

      while (line = value.slice!(/\A[^\r\n]+[\r\n]*/))
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
  end
end
