class User < ApplicationRecord
  # require 'open-uri'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable,
  :omniauthable, omniauth_providers: %i[facebook]
  has_many :bookings, dependent: :nullify
  has_many :reviews
  has_many :reviews, as: :reviewable
  has_many :venues

  has_one_attached :avatar
  enum role: { guest: 0, host: 1, manager: 2, admin: 3 }
  
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.first_name = auth.info.name.split(' ')[0]  # assuming the user model has a name
      user.last_name = auth.info.name.split(' ')[1]   # assuming the user model has a name
      user.full_name = auth.info.name

      # downloaded_image = open(auth.info.image)
      # user.avatar.attach(downloaded_image) # assuming the user model has an image
      # If you are using confirmableand the provider(s) you use validate emails, 
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def user_avatar
   if self.avatar.attached?
      self.avatar.key
    else
      "avatar"
    end
  end

  # def full_name
  #   return "#{first_name.capitalize} #{last_name.capitalize}"
  # end

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

  def full_name
    return "#{first_name.capitalize} #{last_name.capitalize}"
  end
end
