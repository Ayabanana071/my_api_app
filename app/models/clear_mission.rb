class ClearMission < ApplicationRecord
  belongs_to :user

  validates :date, presence: true
  validates :completed_missions_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :total_points, numericality: { only_integer: true }
end
