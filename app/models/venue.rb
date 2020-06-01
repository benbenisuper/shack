class Venue < ApplicationRecord
  CATEGORIES = ["All Categories", "Private House", "Outdoor", "Castle"]
  ACTIVITIES = ["All Activities", "Wedding", "Dinner", "Work"]
  PERKS = ["Internet", "Parking", "Air Conditioning", "Heating", "Security", "Kitchen", "Catering"]
  geocoded_by :location
  belongs_to :user
  has_many :bookings, dependent: :nullify
  has_many :reviews, through: :bookings
  has_many_attached :photos

  validates :name, presence: :true
  validates :category, presence: :true
  validates :activity, presence: :true
  validates :location, presence: :true
  validates :description, presence: :true
  validates :capacity, presence: :true
  validates :price, presence: :true

  after_validation :geocode, if: :will_save_change_to_location?

  def average_rating
    sum = 0

    self.reviews.each do |review|
      sum += review.rating
    end

    if self.reviews.length == 0
      ""
    else
      sum.fdiv(self.reviews.length)
    end
  end

  def unavailable_dates

      bookings.pluck(:start_date, :end_date).map do |range|
        { from: range[0], to: range[1] }

    end
  end

  def venue_image
    if self.photos.attached?
      self.photos.first.key
    else
      "defaultEventImage"
    end
  end

  def self.perk_icon(perk)
    case perk
      when "Internet"
        string = 'wifi'
      when "Parking"
        string = 'parking'
      when "Air Conditioning"
        string = 'wind'
      when "Heating"
        string = 'fire'
      when "Security"
        string = 'user-shield'
      when "Kitchen"
        string = 'utensils'
      when "Catering"
        string = 'cheese'
      else
        string = 'question'
      end
      return string
  end

end
