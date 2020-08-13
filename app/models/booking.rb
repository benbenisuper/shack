class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :venue
  monetize :amount_cents

  has_many :reviews, as: :reviewable
  has_one :chat_box, dependent: :destroy

  validates :start_date, presence: true
  validates :end_date, presence: true

  enum status: [:pending, :cancelled, :approved, :ongoing, :finished, :deleted]

  after_create :create_chat_box, :async_cancel

  def is_completed?
    (Date.today - 3) > self.end_date
  end

  def is_commented?
    !Review.find_by(booking_id: self.id).nil?
  end

  def user_is_commented?
    !Review.find_by(booking_id: self.id, reviewable_type: "User", reviewable_id: self.user.id).nil?
  end

  def can_comment?
    is_completed? && !is_commented?
  end

  def host_can_comment?
    is_completed? && !user_is_commented?
  end

  def show_comment?
    is_completed? && is_commented?
  end

  def host_show_comment?
    is_completed? && user_is_commented?
  end


  def days
    number = (self.end_date.day() - self.start_date.day()).to_i + 1
    number == 1 ? text = "#{number} day" : text = "#{number} days"
    return text
  end

  def hours
    hours = (self.end_date - self.start_date) / 3600
    return hours.to_i
  end

  def local_start_date
    timezone = ActiveSupport::TimeZone[self.venue.zone]
    return timezone.parse("#{self.start_date}")
  end

  def local_end_date
    timezone = ActiveSupport::TimeZone[self.venue.zone]
    return timezone.parse("#{self.end_date}")
  end

  def is_passed?
    answer = false
    local_time_now = ActiveSupport::TimeZone[self.venue.zone].parse("#{Time.now}")
    if local_time_now > local_end_date
      answer = true
    end
    return answer
  end

  def update_status
    self.status = "finished" if is_completed?
    self.save
  end

  def booking_status_icon
    case self.status
    when "pending"
      "far fa-credit-card"
    when "approved"
      "far fa-thumbs-up"
    when "cancelled"
      "fas fa-ban"
    when "ongoing"
      "fas fa-ban"
    when "finished"
      "far fa-calendar-check"
    when "deleted"
      "fas fa-trash-alt"
    end
  end

  private

  def async_cancel
    CancelBookingJob.set(wait: 48.hour).perform_later(self.id)
  end

  def create_chat_box
    ChatBox.create!(booking: self)
  end
end
