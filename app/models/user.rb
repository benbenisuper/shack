class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  		:recoverable, :rememberable, :validatable
  has_many :bookings, dependent: :nullify
  has_many :reviews
  has_many :venues

  has_one_attached :avatar
  enum role: { guest: 0, host: 1, manager: 2, admin: 3 }
  
  def user_avatar
  	if self.avatar.attached?
  		self.avatar.key
  	else
  		"avatar"
  	end
  end

  def full_name
    return "#{first_name.capitalize} #{last_name.capitalize}"
  end

  def next_checkin
    answer = ''
    venue_dates = []
    self.venues.each do |venue|
      unless venue.upcoming_checkin_date[:string] == 'none'
        venue_dates << venue.upcoming_checkin_date
      end
    end
    unless venue_dates.empty?
      bookings = venue_dates.sort_by{ |booking| booking[:date] }
      answer = { date: bookings.first[:date], 
                 string: bookings.first[:date].strftime("%B %d, %Y at %H:%M"),
                 url: "/bookings/#{bookings.first[:booking].id}"
               }
    else
      answer = { date: 'none', string: 'none', url: '/dashboard' }
    end
    return answer
  end

  def next_checkout
    answer = ''
    venue_dates = []
    self.venues.each do |venue|
      unless venue.upcoming_checkout_date[:string] == 'none'
        venue_dates << venue.upcoming_checkout_date
      end
    end
    unless venue_dates.empty?
      bookings = venue_dates.sort_by{ |booking| booking[:date] }
      answer = { date: bookings.first[:date], 
                 string: bookings.first[:date].strftime("%B %d, %Y at %H:%M"),
                 url: "/bookings/#{bookings.first[:booking].id}"
               }
    else
      answer = { date: 'none', string: 'none', url: '/dashboard' }
    end
    return answer
  end
end
