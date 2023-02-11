class Ward < ApplicationRecord
  has_many :user_wards
  has_many :reviews
end
