class ReservationParticipant < ApplicationRecord
  belongs_to :reservation
  belongs_to :user

  validates :user_id, uniqueness: { scope: :reservation_id }
end

