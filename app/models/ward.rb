class Ward < ApplicationRecord
  CATEGORIES = ["Ruby", "JavaScript", "CSS"]
  has_many :user_wards, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many_attached :photos
  has_many :messages, dependent: :destroy
end
