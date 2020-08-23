class User < ApplicationRecord
  # require 'open-uri'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook stripe_connect]
  has_many :bookings, dependent: :nullify
  has_many :reviews
  has_many :reviews, as: :reviewable
  has_many :messages, dependent: :destroy
  has_many :venues

  has_one_attached :avatar
  enum role: { guest: 0, host: 1, manager: 2, admin: 3 }

  def can_receive_payments?
    uid? && provider? && access_code? && publishable_key?
  end

  def self.find_for_facebook_oauth(auth)
    user_params = auth.slice("provider", "uid")
    user_params.merge! auth.info.slice("email")
    user_params[:first_name] = auth.info.name.split(' ')[0]
    user_params[:last_name] = auth.info.name.split(' ')[1]
    user_params[:facebook_picture_url] = auth.info.image
    user_params[:token] = auth.credentials.token
    user_params[:token_expiry] = Time.at(auth.credentials.expires_at)
    user_params = user_params.to_h

    user = User.find_by(provider: auth.provider, uid: auth.uid)
    user ||= User.find_by(email: auth.info.email) # User did a regular sign up in the past.
    if user
      user.update(user_params)
    else
      user = User.new(user_params)
      user.password = Devise.friendly_token[0, 20] # Fake password for validation
      user.save
    end

    return user
  end

  def avatar_url
    if self.avatar.attached?
      self.avatar.service_url
    else
      "https://res.cloudinary.com/mhoare/image/upload/c_fill,g_faces,h_300,w_300/avatar"
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
      bookings = venue_dates.sort_by { |booking| booking[:date] }
      answer = { date: bookings.first[:date],
                 string: bookings.first[:date].strftime("%B %d, %Y at %H:%M"),
                 url: "/bookings/#{bookings.first[:booking].id}" }
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
                 url: "/bookings/#{bookings.first[:booking].id}" }
    else
      answer = { date: 'none', string: 'none', url: '/dashboard' }
    end
    return answer
  end

  def admin
    answer = self.role == "admin" ? true : false
    return answer
  end

  def full_name
    return "#{first_name.capitalize} #{last_name.capitalize}"
  end
end
