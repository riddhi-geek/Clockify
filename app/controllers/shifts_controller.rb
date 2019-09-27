class ShiftsController < ApplicationController
	before_action :set_shift, except: [:index, :new, :create]

	def index
		@shifts = current_user.shifts
	end

	def show
		# @clock_events = @shift.clock_events
		# unless @clock_events.blank?
		# 	@clock_event_status = @shift.get_clock_out_event
		# 	# To display last clock out time
		# 	@last_clock_out = @clock_events.last.clock_out if @clock_event_status.blank?
		# end
		# @clock_out =@shift.clock_events.where(clock_out: nil)

	end

	def new
		@shift = current_user.shifts.new
	end

	def edit; end

	def create
		@shift = current_user.shifts.new(shift_params)
		if @shift.save
			flash[:notice] = "Your shift is created"
			redirect_to shifts_path
		else
			flash[:alert] = @shift.errors.full_messages.join(",")
			render 'new'
		end
	end

	def update
		if @shift.update_attributes(shift_params)
			flash[:notice] = "Your shift has been updated"
			redirect_to shifts_path
		else
			flash[:alert] = @shift.errors.full_messages.join(",")
			render 'edit'
		end
	end

	def destroy
		@shift.destroy
		flash[:notice] = "Your shift has been destroyed!"
		redirect_to shifts_path
	end

	def clock_in
		@clock_event = ClockEvent.new(shift: @shift, clock_in: Time.now)
		if @clock_event.save
			flash[:notice] = "You clocked in at #{@clock_event.clock_in.strftime("%H:%M:%S on %d/%m/%Y")}"
			redirect_to shifts_path
		else
			puts @clock_event.errors.full_messages
			flash[:alert] = "Please, clock out first!"
			render 'shifts/show'
		end
	end

	def clock_out
		# Search the clock event where clock_out is nil
		if @shift.get_clock_out_event&.update(clock_out: Time.now)
			flash[:notice] = "You have clocked out of the system at #{@shift.get_last_clock_out_time}"
			redirect_to shifts_path
		else
			flash[:alert] = "Please, clock in first!"
			render 'shifts/show'
		end
	end

	private

	def set_shift
		@shift = current_user.shifts.find_by(id: params[:id])
		missing_path if @shift.blank?
	end

	def shift_params
		params.require(:shift).permit(:shift_date, :title)
	end
end
