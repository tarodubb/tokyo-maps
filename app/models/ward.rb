class Ward < ApplicationRecord
  has_many :user_wards, :reviews
end
