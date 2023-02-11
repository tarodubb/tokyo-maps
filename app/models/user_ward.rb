class UserWard < ApplicationRecord
  belongs_to :user, :ward
end
