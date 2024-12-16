class Point < ApplicationRecord
  belongs_to :user

  validates :amount, presence: true, numericality: { only_integer: true }
  validates :granted_at, presence: true
end
