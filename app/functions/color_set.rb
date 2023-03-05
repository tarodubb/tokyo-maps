require_relative "./extrusion_height"
class ColorSet
  @max_r = 224
  @max_g = 77
  @max_b = 42
  @min_r = 1
  @min_g = 1
  @min_b = 1
  def self.color_set(avg_rent_max_array, avg_rent_min_array, safety_array)
    # Set main color (The higher the number the darker the color)
    # Set hover color
    hover_red = 255
    hover_green = 255
    hover_blue = 255

    min_1ldk = avg_rent_min_array[0]
    min_2ldk = avg_rent_min_array[1]
    min_3ldk = avg_rent_min_array[2]

    max_1ldk = avg_rent_max_array[0]
    max_2ldk = avg_rent_max_array[1]
    max_3ldk = avg_rent_max_array[2]

    max_safety = safety_array[0]
    min_safety = safety_array[1]

    wards_geojson = File.read("public/tokyo.geojson")
    wards_parsed_geojson = JSON.parse(wards_geojson)

    wards_parsed_geojson["features"].each do |feature|
      ward_1ldk = feature["properties"]["one_ldk_sort_height"]
      ward_2ldk = feature["properties"]["two_ldk_sort_height"]
      ward_3ldk = feature["properties"]["three_ldk_sort_height"]
      ward_safety = feature["properties"]["safety"]
      # 1ldk + safety
      feature["properties"]["one_ldk_sort_color"] = rgb(ward_1ldk, max_1ldk, min_1ldk)
      feature["properties"]["one_ldk_safety_color"] = rgb(ward_safety, max_safety, min_safety)
      # 2ldk + safety
      feature["properties"]["two_ldk_sort_color"] = rgb(ward_2ldk, max_2ldk, min_2ldk)
      feature["properties"]["two_ldk_safety_color"] = rgb(ward_safety, max_safety, min_safety)
      # 3ldk + safety
      feature["properties"]["three_ldk_sort_color"] = rgb(ward_3ldk, max_3ldk, min_3ldk)
      feature["properties"]["three_ldk_safety_color"] = rgb(ward_safety, max_safety, min_safety)
      # safety
      feature["properties"]["safety"] = rgb(ward_safety, max_safety, min_safety)
    end
    File.write('public/tokyo.geojson', JSON.pretty_generate(wards_parsed_geojson))
  end

  def self.rgb(sort_val, max, min)
    normalized_val = (sort_val.to_f - min).fdiv(max - min)
    red = @max_r - ((@max_r - @min_r) * normalized_val)
    green = @max_g - ((@max_g - @min_g) * normalized_val)
    blue = @max_b - ((@max_b - @min_b) * normalized_val)
    "rgb(#{red.round.abs},#{green.round.abs},#{blue.round.abs})"
  end
end
