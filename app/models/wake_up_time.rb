class WakeUpTime < ApplicationRecord
  belongs_to :user

  # バリデーションの追加
  validates :user_id, presence: true
  validates :wake_up_time, presence: true
end
