require_relative "./extrusion_height"
class ColorSet
  @max_r = 224
  @max_g = 77
  @max_b = 42
  @min_r = 1
  @min_g = 1
  @min_b = 1
  def self.color_set(avg_rent_max_array, avg_rent_min_array, safety_array)
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
      # Bundle them to send to methods
      one_ldk = { val: ward_1ldk, max: max_1ldk, min: min_1ldk }
      two_ldk = { val: ward_2ldk, max: max_2ldk, min: min_2ldk }
      three_ldk = { val: ward_3ldk, max: max_3ldk, min: min_3ldk }
      safety = { val: ward_safety, max: max_safety, min: min_safety }

      # 1ldk + safety
      feature["properties"]["one_ldk_sort_color"] = normalize(one_ldk)
      feature["properties"]["one_ldk_safety_color"] = normalize(one_ldk, safety)
      # 2ldk + safety
      feature["properties"]["two_ldk_sort_color"] = normalize(two_ldk)
      feature["properties"]["two_ldk_safety_color"] = normalize(two_ldk, safety)
      # 3ldk + safety
      feature["properties"]["three_ldk_sort_color"] = normalize(three_ldk)
      feature["properties"]["three_ldk_safety_color"] = normalize(two_ldk, safety)
      # safety
      feature["properties"]["safety"] = normalize(safety)
    end
    File.write('public/tokyo.geojson', JSON.pretty_generate(wards_parsed_geojson))
  end

  def self.normalize(sort_val1, sort_val2 = nil)
    if sort_val1 && sort_val2
      val1_norm = (sort_val1[:val] - sort_val1[:min]).fdiv(sort_val1[:max] - sort_val1[:min])
      val2_norm = (sort_val2[:val] - sort_val2[:min]).fdiv(sort_val2[:max] - sort_val2[:min])
      norm = (val1_norm + val2_norm).fdiv(2)
      rgb(norm)
    else
      val_norm = (sort_val1[:val] - sort_val1[:min]).fdiv(sort_val1[:max] - sort_val1[:min])
      rgb(val_norm)
    end
  end

  def self.rgb(normalized_val)
    p normalized_val
    red = @max_r - ((@max_r - @min_r) * normalized_val)
    green = @max_g - ((@max_g - @min_g) * normalized_val)
    blue = @max_b - ((@max_b - @min_b) * normalized_val)
    "rgb(#{red.round.abs},#{green.round.abs},#{blue.round.abs})"
  end
end
