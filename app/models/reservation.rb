class Reservation < ApplicationRecord
  belongs_to :room
  belongs_to :user

  has_many :reservation_participants, dependent: :destroy
  has_many :participants, through: :reservation_participants, source: :user

  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :title, presence: true
end

