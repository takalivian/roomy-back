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

   # 管理者が 0 人にならないようにする
   before_update :ensure_company_has_at_least_one_admin
   before_destroy :ensure_company_has_at_least_one_admin

   private

   def ensure_company_has_at_least_one_admin
     # もともと admin でない場合は制約対象外
     return unless role_before_last_save == "admin"

     # 更新で admin 以外になる or 削除される場合にチェック
     becoming_non_admin = destroyed_by_association.present? || role != "admin"

     return unless becoming_non_admin

     if company.users.admin.count <= 1
       errors.add(:base, "会社には最低1人の管理者が必要です")
       throw :abort
     end
   end
end
