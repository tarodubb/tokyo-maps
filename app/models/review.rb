class Review < ApplicationRecord
  belongs_to :user, :ward
  validates :rating, :content, prescence: true
end
