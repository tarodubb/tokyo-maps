class Ward < ApplicationRecord
  has_many :user_wards, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many_attached :photos
end
