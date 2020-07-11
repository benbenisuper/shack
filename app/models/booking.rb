class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :venue
  monetize :amount_cents

  has_many :reviews, as: :reviewable
  has_one :chat_box

  validates :start_date, presence: true
  validates :end_date, presence: true

  enum status: [:pending, :cancelled, :approved, :ongoing, :finished, :deleted]

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

  def update_status
    self.status = "finished" if is_completed?
    self.save
  end
end
