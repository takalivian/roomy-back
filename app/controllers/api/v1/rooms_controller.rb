class Api::V1::RoomsController < ApplicationController
  before_action :authenticate_user_with_jwt!
  before_action :set_company
  before_action :set_room, only: %i[show update destroy]

  def index
    render json: @company.rooms
  end

  def show
    render json: @room
  end

  def create
    return render json: { error: "Forbidden" }, status: :forbidden unless @current_user.admin?

    room = @company.rooms.new(room_params)

    if room.save
      render json: room, status: :created
    else
      render json: { errors: room.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    return render json: { error: "Forbidden" }, status: :forbidden unless @current_user.admin?

    if @room.update(room_params)
      render json: @room
    else
      render json: { errors: @room.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    return render json: { error: "Forbidden" }, status: :forbidden unless @current_user.admin?

    @room.destroy!
    head :no_content
  end

  private

  def set_company
    @company = @current_user.company
  end

  def set_room
    @room = @company.rooms.find(params[:id])
  end

  def room_params
    params.require(:room).permit(:name)
  end
end

