class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :venue

  has_one :review

  validates :start_date, presence: true
  validates :end_date, presence: true

  def is_completed?
    (Date.today + 3) > self.end_date
  end

  def is_commented?
    !Review.find_by(booking_id: self.id).nil?
  end

  def can_comment?
    is_completed? && !is_commented?
  end

  def show_comment?
    is_completed? && is_commented?
  end

  def days
    number = (self.end_date.day() - self.start_date.day()).to_i + 1
    number == 1 ? text = "#{number} day" : text = "#{number} days"
    return text
  end

  def status_nice
    return "Payment pending" if self.status == "1"
    return "Confirmed" if self.status == "2"
    return "Finished" if self.status == "3"
    return "PROBLEM"
  end

  def update_status
    self.status = "3" if is_completed?
    self.save
  end
end
