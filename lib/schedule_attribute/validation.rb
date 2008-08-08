module ActiveRecord
  module Validations
    module ClassMethods
      def validates_as_schedule_attribute(*args)
        configuration = { :message => ActiveRecord::Errors.default_error_messages[:invalid], :type => :weekly }
        configuration.update(args.pop) if args.last.is_a?(Hash)

        validates_each(args, configuration) do |record, attr_name, value|
          record.errors.add(attr_name, configuration[:message]) unless valid_schedule?(configuration[:type], value)
        end
      end

      protected

      def valid_schedule?(type, value)
        new_value = String.new(value)

        while (line = new_value.slice!(/\A[^\r\n]+[\r\n]*/))
          unless line.to_s =~ ScheduleAttribute::Constants::FORMAT_EXPRESSIONS[type]
            return false
          end

          line = new_value.slice!(/\A[^\r\n]+[\r\n]*/)
          unless line =~ ScheduleAttribute::Constants::FORMAT_EXPRESSIONS[type]
            return false
          end
        end

        return true
      end
    end
  end
end
