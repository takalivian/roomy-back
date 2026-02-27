class Company < ApplicationRecord
  has_many :users, dependent: :destroy

  # バリデーション
  validates :name, presence: true
end
