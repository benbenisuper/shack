class Review < ApplicationRecord
  belongs_to :user
  belongs_to :booking
  belongs_to :reviewable, polymorphic: true

  validates :title, presence: true
  validates :comment, presence: true
  validates :rating, presence: true, inclusion: [1, 2, 3, 4, 5]
end
