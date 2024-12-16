class UsersController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save
      render json: { message: 'User created successfully' }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def search
    query = params[:query]
    users = User.where('name LIKE ?', "%#{query}%").limit(10)
    render json: users, status: :ok
  end

  private

  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation)
  end
end
