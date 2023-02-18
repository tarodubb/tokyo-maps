class AddRefsToUserWards < ActiveRecord::Migration[7.0]
  def change
    add_reference :user_wards, :user, null: false, foreign_key: true
    add_reference :user_wards, :ward, null: false, foreign_key: true
  end
end
