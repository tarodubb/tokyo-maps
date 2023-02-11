class UserWard < ApplicationRecord
  belongs_to :user
  belongs_to :ward
end
