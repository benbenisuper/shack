class Day < ApplicationRecord
  belongs_to :calendar

  def available_for_hour(hour)
    venue = self.calendar.venue
  	date = self.date + hour.hour
    tz = ActiveSupport::TimeZone[venue.zone]
    min_time = tz.parse("#{self.day}/#{self.month}/#{self.year} #{self.min_time}")
    max_time = tz.parse("#{self.day}/#{self.month}/#{self.year} #{self.max_time}")
  	bookings = venue.bookings.where(status: ["approved", "ongoing"])
  	available = true
  	bookings.each do |booking|
  		if (booking.start_date <= date) && (date < booking.end_date)
  			available = false
  		end
  	end
    if (max_time.to_time <= date.to_time) || (min_time.to_time > date.to_time)
        available = false
      end
    return available	
  end

  def has_booking
    venue = self.calendar.venue
    date = ActiveSupport::TimeZone[venue.zone].parse("#{self.day}/#{self.month}/#{self.year}")
    bookings = venue.bookings.where(status: ["approved", "ongoing"])
    has_booking = "no_booking"
    bookings.each do |booking|
      if (booking.start_date.to_date == date.to_date) 
        has_booking = "has_booking"
      end
    end
    return has_booking
  end

end
