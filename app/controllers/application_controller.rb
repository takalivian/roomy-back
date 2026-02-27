class ApplicationController < ActionController::API
  private

  def encode_token(payload)
    exp = 1.hour.from_now.to_i
    JWT.encode(payload.merge(exp: exp), Rails.application.secret_key_base, "HS256")
  end

  def decoded_token
    auth_header = request.headers["Authorization"]
    return nil unless auth_header&.start_with?("Bearer ")

    token = auth_header.split(" ").last
    JWT.decode(
      token,
      Rails.application.secret_key_base,
      true,
      { algorithm: "HS256" }
    ).first
  rescue JWT::DecodeError, JWT::ExpiredSignature
    nil
  end

  def authenticate_user_with_jwt!
    decoded = decoded_token
    user_id = decoded && decoded["user_id"]
    @current_user = User.find_by(id: user_id)

    unless @current_user
      render json: { error: "Unauthorized" }, status: :unauthorized
      return
    end

    # スライディング有効期限: 有効なアクセスごとに新しいトークンを発行して返す
    new_token = encode_token(user_id: @current_user.id)
    response.set_header("X-Auth-Token", new_token)
  end
end
