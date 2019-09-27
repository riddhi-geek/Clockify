class ClockEventsController < ApplicationController
	before_action :set_shift
	before_action :set_clock_event

	def edit
		respond_to do |format|
			format.js
		end
	end

	def update
		if @clock_event.update_attributes(clock_event_params)
			flash[:notice] = "Clock event has been updated"
		else
			flash[:alert] = @clock_event.errors.full_messages.join(", ")
		end
		redirect_to shift_path(@shift)
	end

	def destroy
		@clock_event.destroy
		flash[:notice] = "Clock event has been destroyed."
		redirect_to shift_path(@shift)
	end

	private

	def set_shift
		@shift = current_user.shifts.find_by(id: params[:shift_id])
		missing_path if @shift.blank?
	end

	def set_clock_event
		@clock_event = @shift.clock_events.find_by(id: params[:id])
		missing_path if @clock_event.blank?
	end

	def clock_event_params
		params.require(:clock_event).permit(:clock_in, :clock_out)
	end
end
