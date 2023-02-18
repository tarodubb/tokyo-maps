class AddWardCodeToWard < ActiveRecord::Migration[7.0]
  def change
    add_column :wards, :ward_code, :integer
  end
end
