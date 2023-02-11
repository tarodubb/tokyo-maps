class Review < ApplicationRecord
  belongs_to :user
  belongs_to :ward
  validates :rating, :content, prescence: true
end
