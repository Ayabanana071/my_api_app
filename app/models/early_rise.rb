class EarlyRise < ApplicationRecord
  belongs_to :user

  # バリデーション
  validates :wake_up_time, presence: true
  validates :status, inclusion: { in: %w[成功 失敗 未設定], message: "は成功、失敗、未設定のいずれかで指定してください" }
end
