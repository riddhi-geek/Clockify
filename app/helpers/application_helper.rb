module ApplicationHelper
	def header(text)
		content_for(:header) { text.to_s }
	end

	def formatted_date(date)
		if date
			return date.strftime("%d/%m/%Y")
		end
	end

	def formatted_datetime(datetime)
		if datetime
			return datetime.strftime("%H:%M:%S %d/%m/%Y")
		end
	end
end
