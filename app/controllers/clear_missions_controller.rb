class ClearMissionsController < ApplicationController
  before_action :authenticate_user!

  def create_or_update
    date = params[:date]&.to_date
    unless date
      render json: { error: 'Date is required' }, status: :unprocessable_entity
      return
    end

    clear_mission = ClearMission.find_or_initialize_by(user: current_user, date: date)
    clear_mission.completed_missions_count = params[:completed_missions_count].to_i
    clear_mission.total_points = params[:total_points].to_i

    if clear_mission.save
      render json: { message: 'Clear mission saved successfully', clear_mission: clear_mission }, status: :ok
    else
      render json: { error: clear_mission.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    start_date = params[:start_date]&.to_date
    end_date = params[:end_date]&.to_date

    if start_date.nil? || end_date.nil?
      render json: { error: 'Start date and end date are required' }, status: :unprocessable_entity
      return
    end

    missions = current_user.clear_missions.where(date: start_date..end_date)
    render json: missions
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
