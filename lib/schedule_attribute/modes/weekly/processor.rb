module ScheduleAttribute
  module Modes
    module Weekly
      class Processor
        attr_accessor :schedule_object, :schedule_attribute, :processor_hash

        def self.set_schedule(object, attribute, hash)
          schedule_object = object
          schedule_attribute = attribute

          object.send(attribute.to_s + "=", "")

          (0..6).each do |i|
            start_sym = ("start_" + i.to_s)
            end_sym = ("end_" + i.to_s)
            puts "start: " + hash[start_sym].inspect
            puts "end: " + hash[end_sym].inspect
            append_to_attribute(object, attribute, "\n\n" + i.to_s + " " + hash[start_sym] + "\n" + i.to_s + " " + hash[end_sym]) unless hash[start_sym].blank? || hash[end_sym].blank?
          end
        end

        protected

        def self.append_to_attribute(object, attribute, string)
          object.send(attribute.to_s + "=", object.send(attribute.to_s).to_s + string.to_s)
        end
      end
    end
  end
end
