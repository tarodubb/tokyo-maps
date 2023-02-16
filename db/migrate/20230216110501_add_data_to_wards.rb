class AddDataToWards < ActiveRecord::Migration[7.0]
  def change
    add_column :wards, :points_of_interest, :text, array: true
    add_column :wards, :historical_significance, :string
  end
end
