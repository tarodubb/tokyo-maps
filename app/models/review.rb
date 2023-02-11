class Review < ApplicationRecord
  belongs_to :user, :ward
end
