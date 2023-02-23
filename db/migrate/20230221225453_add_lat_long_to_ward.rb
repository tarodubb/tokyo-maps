class AddLatLongToWard < ActiveRecord::Migration[7.0]
  def change
    add_column :wards, :latitude, :float
    add_column :wards, :longitude, :float
  end
end
