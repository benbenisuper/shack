class Calendar < ApplicationRecord
  belongs_to :venue
  has_many :days, dependent: :destroy

  after_create :create_days

  def update_hour_price_for_wday(weekday, new_price)
  	self.days.where(wday: weekday.to_i).each do |day|
  		day.update(hour_price_cents: new_price * 100)
  	end
  end

  def update_day_price_for_wday(weekday, new_price)
  	self.days.where(wday: weekday.to_i).each do |day|
  		day.update(day_price_cents: new_price * 100)
  	end
  end

  def update_hour_price_for_wday_of_month(month, weekday, new_price)
  	self.days.where(wday: weekday.to_i, month: month.to_i).each do |day|
  		day.update(hour_price_cents: new_price * 100)
  	end
  end

  def update_day_price_for_wnum_of_year(year, weeknum, new_price)
    self.days.where(wnum: weeknum.to_i, year: year.to_i).each do |day|
      day.update(day_price_cents: new_price * 100)
    end
  end

  def update_hour_price_for_wnum_of_year(year, weeknum, new_price)
    self.days.where(wnum: weeknum.to_i, year: year.to_i).each do |day|
      day.update(hour_price_cents: new_price * 100)
    end
  end

  def update_day_price_for_wday_of_month(month, weekday, new_price)
  	self.days.where(wday: weekday.to_i, month: month.to_i).each do |day|
  		day.update(day_price_cents: new_price * 100)
  	end
  end

  def update_hour_price_for_month(month, new_price)
  	self.days.where(month: month.to_i).each do |day|
  		day.update(hour_price_cents: new_price * 100)
  	end
  end

  def update_day_price_for_month(month, new_price)
  	self.days.where(month: month.to_i).each do |day|
  		day.update(day_price_cents: new_price * 100)
  	end
  end

  def modify_price_for_month_by(month, percent)
  	self.days.where(month: month.to_i).each do |day|
  		day.update(day_price_cents: day.day_price_cents * (1 + percent))
  	end
  end

  def modify_price_for_wday_by(weekday, percent)
  	self.days.where(wday: weekday.to_i).each do |day|
  		day.update(day_price_cents: day.day_price_cents * (1 + percent))
  	end
  end

  def modify_price_for_wday_of_month_by(month, weekday, percent)
  	self.days.where(month: month.to_i, wday: weekday).each do |day|
  		day.update(day_price_cents: day.day_price_cents * percent)
  	end
  end

  def update_hour_price_for_date(date, new_price)
  	self.days.find_by(date: date.to_time).update(hour_price_cents: new_price * 100)
  end

  def update_day_price_for_date(date, new_price)
  	self.days.find_by(date: date.to_time).update(day_price_cents: new_price * 100)
  end

  def today
    today = self.days.find_by(date: Date.today)
    self.days.order(:date).index(today)
  end

  def first_day_of_month(year, month)
    self.days.where(month: month, year: year).first
  end

  def first_calendar_day_of_month(year, month)
    days = self.days.order(:date)
    first_day = self.first_day_of_month(year, month)
    first_day_index = days.index(first_day)
    wday = first_day.wday
    first_calendar_day = days[first_day_index - wday]
  end

  def calendar_days_for_month(year, month)
    days = self.days.order(:date)
    first_day = self.first_day_of_month(year, month)
    first_day_index = days.index(first_day)
    first_calendar_day_index = first_day_index - first_day.wday
    first_calendar_day = days[first_calendar_day_index..(first_calendar_day_index + 41)]
  end

  def days_of_this_month(year, month)
    array = []
    self.calendar_days_for_month(year, month).each do |day|
      if day.month == month.to_i
        array << ""
      else
        array << "disabled"
      end
    end
    return array
  end

  def average_day_price_cents
    sum = 0
    days = self.days.where(month: Date.today.month)
    count = days.count
    days.each do |day|
      sum += day.day_price_cents
    end
    return sum / count
  end

  def average_hour_price_cents
    sum = 0
    days = self.days.where(month: Date.today.month)
    count = days.count
    days.each do |day|
      sum += day.hour_price_cents
    end
    return sum / count
  end

  private

  def create_days
    timezone = ActiveSupport::TimeZone[self.venue.zone]
  	first_day = Date.today.at_beginning_of_month.last_month - 20.day
  	last_day = Date.today.at_beginning_of_month.next_month + 1.year + 20.day

  	(first_day..last_day).to_a.each do |date|
  		Day.create!(date: timezone.parse("#{date}"), #-timezone.now.utc_offset,
  			calendar: self,
        day: date.day,
  			month: date.month,
  			year: date.year,
  			wday: date.wday,
        wnum: date.strftime('%U').to_i,
  			hour_price_cents: self.hour_price_cents,
  			day_price_cents: self.day_price_cents,
  			min_time: self.min_time,
  			max_time: self.max_time)
  	end
  end

end
