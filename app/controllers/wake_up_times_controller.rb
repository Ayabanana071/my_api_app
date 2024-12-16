class WakeUpTimesController < ApplicationController
  before_action :authenticate_user! # ユーザー認証が必要な場合

  def create
    wake_up_time = current_user.wake_up_times.new(wake_up_time_params)
    if wake_up_time.save
      render json: { message: 'Wake up time saved successfully' }, status: :created
    else
      render json: { errors: wake_up_time.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def wake_up_time_params
    params.require(:wake_up_time).permit(:wake_up_time)
  end

  private

  def authenticate_user!
    token_value = request.headers['Authorization']&.split(' ')&.last # "Bearer token" の "token" を取り出す
    puts "Received token: #{token_value}" 
    if token_value.nil? || token_value.empty?
      render json: { error: 'Token is missing' }, status: :unauthorized
      return
    end
    
    @current_token = Token.find_by(value: token_value)
    
    if @current_token
      @current_user = @current_token.user
    else
      render json: { error: 'Invalid token' }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end
end
