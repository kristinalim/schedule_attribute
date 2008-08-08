require 'schedule_attribute'
require 'schedule_attribute/constants'
require 'schedule_attribute/conversions'
require 'schedule_attribute/validation'

ActiveRecord::Base.send(:include, ScheduleAttribute)
