class SessionsController < ApplicationController
  def create
    user = User.find_by(name: params[:name])
    if user&.authenticate(params[:password])
      token = SecureRandom.hex
      Token.create!(value: token, user: user)

      render json: { token: token, user_id: user.id }, status: :ok
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  def show
    token = Token.find_by(value: request.headers['Authorization'])
    if token
      render json: { name: token.user.name, created_at: token.user.created_at.strftime("%Y-%m-%d %H:%M:%S") }, status: :ok
    else
      render json: { error: 'Invalid token' }, status: :unauthorized
    end
  end
end
