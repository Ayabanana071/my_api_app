class RankingsController < ApplicationController
  before_action :authenticate_user!

  def weekly
    today = Date.today
    start_of_week = today - (today.wday - 1) % 7
    end_of_week = start_of_week + 6

    # 現在のユーザーの友達を取得
    friends = current_user.friends.includes(:friend)

    # 各友達の1週間のポイントを集計
    friend_scores = friends.map do |friend|
      {
        id: friend.friend.id,
        name: friend.friend.name,
        score: friend.friend.points
                      .where(granted_at: start_of_week.beginning_of_day..end_of_week.end_of_day)
                      .sum(:amount)
      }
    end

    me_score = {
      id: current_user.id,
      name: current_user.name,
      score: current_user.points.where(granted_at: start_of_week.beginning_of_day..end_of_week.end_of_day)
      .sum(:amount)
    }

    scores = friend_scores.push(me_score)
    # スコアの降順でソート
    sorted_scores = scores.sort_by { |f| -f[:score] }

    render json: sorted_scores
  rescue => e
    Rails.logger.error("Error in RankingsController#weekly: #{e.message}")
    render json: { error: 'ランキングデータの取得に失敗しました' }, status: :internal_server_error
  end

  private

  def authenticate_user!
    token_value = request.headers['Authorization']&.split(' ')&.last
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
