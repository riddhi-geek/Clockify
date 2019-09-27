class ClockEvent < ApplicationRecord
	# Associations
	belongs_to :shift

	# Validations
	validates :clock_in, presence: true, if: Proc.new{|obj| !obj.new_record?  }
	validates :clock_out, presence: true, if: Proc.new{|obj| !obj.new_record? }
	validate  :check_clock_out_time

	def check_clock_out_time
		if clock_out && clock_out < clock_in
			errors.add(:clock_out, "time should not be less than clockin time.")
		end
		if !self.new_record? and self.clock_in and self.clock_out
			if ClockEvent.where(shift_id: self.shift_id, clock_in: self.clock_in..self.clock_out, clock_out: self.clock_in..self.clock_out).any?
				errors.add(:clock_event, "Conflict with your existing clock events.")
			end
		end
	end

	def get_total_time
    Time.at(self.clock_out - self.clock_in).utc.strftime "%H:%M:%S"
	end

end
