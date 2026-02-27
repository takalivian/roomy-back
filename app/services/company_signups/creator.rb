class CompanySignups::Creator
  # クラスメソッドを作成
  def self.call(company_params:, admin_params:)
    new(company_params, admin_params).call
  end

  # インスタンスを作成
  def initialize(company_params, admin_params)
    @company_params = company_params
    @admin_params   = admin_params
  end

  # メソッドを作成
  def call
    company = nil
    admin   = nil

    ActiveRecord::Base.transaction do
      company = Company.create!(@company_params)
      admin   = company.users.create!(@admin_params.merge(role: :admin))
    end

    [company, admin]
  end
end