class PointsController < ApplicationController
  before_action :authenticate_user!

  def index
    today = Date.today
    start_of_week = today - (today.wday - 1) % 7
    end_of_week = start_of_week + 6
  
    points = current_user.points.order(granted_at: :desc)
  
    total_points = points.sum(:amount)
  
    current_week_points = points.where(granted_at: start_of_week.beginning_of_day..end_of_week.end_of_day)
    weekly_points_total = current_week_points.sum(:amount)
  
    render json: {
      total_points: total_points || 0,
      current_week_points: current_week_points || [],
      weekly_points_total: weekly_points_total || 0
    }
  rescue => e
    Rails.logger.error("Error in PointsController#index: #{e.message}")
    render json: { error: 'ポイントデータの取得に失敗しました' }, status: :internal_server_error
  end

  def create
    # ユーザーが送信したポイント数を受け取る
    points = params[:amount].to_i
  
    # ユーザーのポイントレコードを作成
    point_record = current_user.points.create(amount: points, granted_at: Time.current)
  
    if point_record.persisted?
      render json: { message: 'ポイントが正常に作成されました', point: point_record }, status: :created
    else
      render json: { errors: point_record.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  # Strong parameters: `points`と`user_id`を許可
  def point_params
    params.require(:point).permit(:points, :user_id)
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
