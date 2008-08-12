module ScheduleAttribute
  module Modes
    module Weekly
      class Helper
        # These helper methods assume that there is only one schedule pair for
        # each weekday, and that the scope of the schedule pair is only within
        # that day.

        def self.render_schedule(schedule, options = {})
          str = "<table#{" class=\"" + options[:table_class] + "\"" unless options[:table_class].blank?}>"
          #str += "<thead><tr><th>Day</th><th>Start</th><th>End</th></tr></thead>"
          str += "<tbody>"
          [[0, "Sunday"], [1, "Monday"], [2, "Tuesday"], [3, "Wednesday"], [4, "Thursday"], [5, "Friday"], [6, "Saturday"]].each do |code, day|
            day_schedule = ScheduleAttribute::Parser.schedule_within_day(:weekly, schedule, code)
            if day_schedule
              str += "<tr>"
              str += "<th class='day'>" + day + "</th>"
              str += "<td>" + pm_format(day_schedule[0]) + " - "
              str += pm_format(day_schedule[1]) + "</td>"
              str += "</tr>"
            end
          end
          str += "</tbody></table>"

          str
        end

        protected

        def self.pm_format(schedule)
          hour = schedule[:hours].to_i % 12
          pm = (schedule[:hours].to_i / 12) > 0

          hour.to_s.rjust(2, "0") + ":" + schedule[:minutes].to_s.rjust(2, "0") + " " + (pm ? "PM" : "AM")
        end
      end
    end
  end
end
