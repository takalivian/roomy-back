class User < ApplicationRecord
  belongs_to :company

  # 権限
  enum :role, {
    admin: 0, # 管理者
    staff: 1  # 一般ユーザー
  }

  # パスワードのハッシュ化
  has_secure_password

  # バリデーション
  validates :name,  presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 8 }
end
