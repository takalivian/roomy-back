class Api::V1::SessionsController < ApplicationController
  def create
    user = User.find_by(email: session_params[:email])

    if user&.authenticate(session_params[:password])
      token = encode_token({ user_id: user.id })
      render json: { token: token, user: user }, status: :ok
    else
      render json: { error: "メールアドレスまたはパスワードが正しくありません" }, status: :unauthorized
    end
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end

