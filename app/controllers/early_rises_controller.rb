class EarlyRisesController < ApplicationController
  before_action :authenticate_user! # ユーザー認証（Deviseなどを想定）

  # 早起き記録を作成する
  def create
    wake_up_time = params[:wake_up_time].to_datetime
    cleared_at = params[:cleared_at].to_datetime

    # 早起き成功判定（1時間以内かどうか）
    status = (cleared_at - wake_up_time) <= 1.hour ? "成功" : "失敗"

    early_rise = current_user.early_rises.new(
      wake_up_time: wake_up_time,
      cleared_at: cleared_at,
      status: status
    )

    if early_rise.save
      render json: { message: "早起き記録を保存しました", early_rise: early_rise }, status: :created
    else
      render json: { errors: early_rise.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # ユーザーの早起き記録一覧を取得
  def index
    wake_up_times = current_user.early_rises
                                .select('early_rises.*')
                                .where('id IN (SELECT MAX(id) FROM early_rises GROUP BY DATE(wake_up_time))')
                                .order('wake_up_time DESC')
                                .map do |record|
      {
        hour: record.wake_up_time.hour,
        minute: record.wake_up_time.min
      }
    end
    pp "================================="
    pp wake_up_times
    render json: wake_up_times
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
