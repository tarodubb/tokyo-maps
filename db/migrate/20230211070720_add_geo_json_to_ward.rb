class AddGeoJsonToWard < ActiveRecord::Migration[7.0]
  def change
    add_column :wards, :geojson, :string
  end
end
