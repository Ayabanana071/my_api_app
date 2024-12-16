class User < ApplicationRecord
  has_secure_password
  has_many :friends, class_name: 'Friend', foreign_key: 'user_id', dependent: :destroy
  has_many :inverse_friends, class_name: 'Friend', foreign_key: 'friend_id'
  has_many :points, dependent: :destroy
  has_many :wake_up_times
  has_many :early_rises, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
