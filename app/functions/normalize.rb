require_relative "./extrusion_height"
class Normalize
  def self.normalize_data
    wards_geojson = File.read("public/tokyo.geojson")
    wards_parsed_geojson = JSON.parse(wards_geojson)
    wards_parsed_geojson["features"].each do |feature|
      one_ldk_sort_coefficient = feature["properties"]["one_ldk_sort_height"].to_i.fdiv(5000)
      two_ldk_sort_coefficient = feature["properties"]["two_ldk_sort_height"].to_i.fdiv(5000)
      three_ldk_sort_coefficient = feature["properties"]["three_ldk_sort_height"].to_i.fdiv(5000)
      ward_safety_coefficient = feature["properties"]["safety"].to_i.fdiv(5000)

      oneldk_safety_height = 5000 * ((one_ldk_sort_coefficient+ ward_safety_coefficient).fdiv(2))
      twoldk_safety_height = 5000 * ((two_ldk_sort_coefficient+ ward_safety_coefficient).fdiv(2))
      threeldk_safety_height = 5000 * ((three_ldk_sort_coefficient+ ward_safety_coefficient).fdiv(2))

      feature["properties"]["one_ldk_safety_height"] = oneldk_safety_height
      feature["properties"]["two_ldk_safety_height"] = twoldk_safety_height
      feature["properties"]["three_ldk_safety_height"] = threeldk_safety_height
    end
    File.write('public/tokyo.geojson', JSON.pretty_generate(wards_parsed_geojson))
  end
end
