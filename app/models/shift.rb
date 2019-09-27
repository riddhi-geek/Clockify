class Shift < ApplicationRecord
	# Associations
	has_many :clock_events, dependent: :destroy
	belongs_to :user

	# Validations
	validates :shift_date, presence:true, inclusion: { in: (Date.today..Date.today), message: 'Can not create future or past shift' }
	validates :title, presence:true, length: { maximum: 255 }
	validates_uniqueness_of :shift_date, scope: :user_id, message: 'You have already created a shift on this day.'

	# This method is created to get the status of clock event
	def get_clock_out_event
		clock_events.where(clock_out: nil).last
	end

	def is_clock_in?
		is_clock_in = false
		if clock_events.blank? || !get_clock_out_event
			is_clock_in = true
		end
		is_clock_in
	end

	def get_last_clock_in_time
		clock_events.last.clock_in.strftime("%H:%M:%S on %d/%m/%Y")
	end

	def get_last_clock_out_time
		clock_events.last.clock_out.strftime("%H:%M:%S on %d/%m/%Y")
	end

	# Get total time of shift
	def total_time_spent
		total_time = 0
		clock_events.each do |clock_event|
		  if clock_event.clock_out
		    time_difference = clock_event.clock_out - clock_event.clock_in
		    total_time += time_difference
		  end
		end
		Time.at(total_time).utc.strftime "%H:%M:%S"
	end
end
