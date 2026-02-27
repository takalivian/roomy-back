class Room < ApplicationRecord
  belongs_to :company

  has_many :reservations, dependent: :destroy

  validates :name, presence: true
end

