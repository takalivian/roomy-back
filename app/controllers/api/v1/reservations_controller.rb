class Api::V1::ReservationsController < ApplicationController
  before_action :authenticate_user_with_jwt!
  before_action :set_company
  before_action :set_room
  before_action :set_reservation, only: %i[show update destroy]

  def index
    render json: @room.reservations
  end

  def show
    render json: @reservation
  end

  def create
    reservation = @room.reservations.new(reservation_params.merge(user: @current_user))

    if reservation.save
      # 作成者をデフォルトの参加者として登録
      reservation.reservation_participants.find_or_create_by!(user: @current_user)
      render json: reservation, status: :created
    else
      render json: { errors: reservation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    # 自分の予約だけ更新可能（ここは要件に応じて変更）
    unless @reservation.user_id == @current_user.id || @current_user.admin?
      return render json: { error: "Forbidden" }, status: :forbidden
    end

    if @reservation.update(reservation_params)
      render json: @reservation
    else
      render json: { errors: @reservation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    # 自分の予約か管理者のみ削除可能
    unless @reservation.user_id == @current_user.id || @current_user.admin?
      return render json: { error: "Forbidden" }, status: :forbidden
    end

    @reservation.destroy!
    head :no_content
  end

  private

  def set_company
    @company = @current_user.company
  end

  def set_room
    @room = @company.rooms.find(params[:room_id])
  end

  def set_reservation
    @reservation = @room.reservations.find(params[:id])
  end

  def reservation_params
    params.require(:reservation).permit(:start_time, :end_time, :title, :remarks)
  end
end

