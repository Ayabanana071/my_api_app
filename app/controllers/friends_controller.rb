class FriendsController < ApplicationController
  before_action :authenticate_user!

  def index
    @friends = current_user.friends.includes(:friend) # eager loadingで関連するユーザーを取得
    render json: @friends.map { |f| { id: f.friend.id, name: f.friend.name } }
  end

  def create
    friend = User.find_by(id: params[:friend_id])
  
    if friend.nil?
      render json: { error: 'Friend not found' }, status: :not_found
      return
    end
  
    # フレンドが自分自身でないことを確認
    if friend.id == current_user.id
      render json: { error: 'Cannot add yourself as a friend' }, status: :unprocessable_entity
      return
    end
  
    # 現在のユーザーとフレンドを追加
    if current_user.friends.exists?(friend_id: friend.id)
      render json: { error: 'Already friends' }, status: :unprocessable_entity
      return
    end
  
    # フレンド追加処理（片方向）
    friend1 = current_user.friends.create(friend: friend)
    # 逆方向のフレンド追加処理
    friend2 = friend.friends.create(friend: current_user)
  
    if friend1.persisted? && friend2.persisted?
      render json: { message: 'Friend added successfully' }, status: :created
    else
      render json: { error: 'Failed to add friend' }, status: :unprocessable_entity
    end
  end

  def rankings
    friends = current_user.friends.includes(:friend).map do |f|
      {
        id: f.friend.id,
        name: f.friend.name,
        score: f.friend.points.sum(:amount) # スコアはポイントの合計と仮定
      }
    end

    ranked_friends = friends.sort_by { |friend| -friend[:score] } # スコア降順にソート
    render json: ranked_friends
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
