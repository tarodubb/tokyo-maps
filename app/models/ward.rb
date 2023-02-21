class Ward < ApplicationRecord
  has_many :user_wards, dependent: :destroy
  has_many :reviews, dependent: :destroy

  # def one_ldk_rent_low_to_high
  #   Ward.sort_by(&:one_ldk_avg_rent)
  # end
end
