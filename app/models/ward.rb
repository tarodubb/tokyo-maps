class Ward < ApplicationRecord
  has_many :user_wards, dependent: :destroy
  has_many :reviews, dependent: :destroy
end
