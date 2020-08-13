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

  def bookings
    venue = self.calendar.venue
    bookings = venue.bookings.where(status: ["approved", "ongoing"])
    date = ActiveSupport::TimeZone[venue.zone].parse("#{self.day}/#{self.month}/#{self.year}")
    day_bookings = []
    bookings.each do |booking|
      if (booking.start_date.to_date == date.to_date) 
        day_bookings << booking
      end
    end
    return day_bookings
  end

  def has_booking
    has_booking = "no_booking"
    if (self.bookings.count > 0) 
      has_booking = "has_booking"
    end
    return has_booking
  end

end
