class Company < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :rooms, dependent: :destroy

  # バリデーション
  validates :name, presence: true
end
