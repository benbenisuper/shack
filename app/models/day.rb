class Day < ApplicationRecord
  belongs_to :calendar

  def available_for_hour(hour)
    venue = self.calendar.venue
  	date = self.date + hour.hour
  	bookings = venue.bookings.where(status: ["approved", "ongoing"])
  	available = true
  	bookings.each do |booking|
  		if (booking.start_date <= date) && (booking.end_date > date)
  			available = false
  		end
  	end
    return available	
  end
end
