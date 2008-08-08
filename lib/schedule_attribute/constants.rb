module ScheduleAttribute
  class Constants
    FORMAT_EXPRESSIONS = {
        :day => /([0-6]|sun|mon|tue|wed|thu|fri|sat)/i,
        :hour => /([0-1]?[0-9]|[2][0-3])/,
        :minute => /([0-5]?[0-9])/,
        :weekly => /([0-6]|sun|mon|tue|wed|thu|fri|sat) ([0-1]?[0-9]|[2][0-3]) ([0-5]?[0-9])[\r\n]*/
    }

    VALUE_HASH = {
        :day => {"sun" => 0, "mon" => 1, "tue" => 2, "wed" => 3, "thu" => 4, "fri" => 5, "sat" => 6}
    }
  end
end
