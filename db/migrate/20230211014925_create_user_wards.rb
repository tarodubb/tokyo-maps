class CreateUserWards < ActiveRecord::Migration[7.0]
  def change
    create_table :user_wards do |t|

      t.timestamps
    end
  end
end
