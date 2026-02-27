class Api::V1::CompanySignupsController < ApplicationController
  def create
    # 企業と管理者を同時に作成
    company, admin = CompanySignups::Creator.call(
      company_params: company_params,
      admin_params:   admin_params
    )
  
    # 作成した企業と管理者を返す
    render json: { company: company, admin: admin }, status: :created

    # 作成に失敗した場合はエラーメッセージを返す
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  private

  # 企業のパラメータを取得
  def company_params
    params.require(:company).permit(:name)
  end

  # 管理者のパラメータを取得
  def admin_params
    params.require(:admin).permit(:name, :email, :password, :password_confirmation)
  end
end
