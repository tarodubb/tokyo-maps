require_relative "./get_average"
class ColorSet
  @max_r = 255
  @max_g = 255
  @max_b = 255
  @min_r = 1
  @min_g = 1
  @min_b = 117
  @no_schools = "rgb(85,85,85)"
  def self.color_set(avg_max, avg_min)
    min_1ldk = avg_min[:oneldk]
    min_2ldk = avg_min[:twoldk]
    min_3ldk = avg_min[:threeldk]
    min_safety = avg_min[:safety]
    min_school_count = avg_min[:international_schools]

    max_1ldk = avg_max[:oneldk]
    max_2ldk = avg_max[:twoldk]
    max_3ldk = avg_max[:threeldk]
    max_safety = avg_max[:safety]
    max_school_count = avg_max[:international_schools]

    wards_geojson = File.read("public/tokyo.geojson")
    wards_parsed_geojson = JSON.parse(wards_geojson)

    wards_parsed_geojson["features"].each do |feature|
      ward_1ldk = feature["properties"]["one_ldk"]
      ward_2ldk = feature["properties"]["two_ldk"]
      ward_3ldk = feature["properties"]["three_ldk"]
      ward_safety = feature["properties"]["safety"]
      ward_schools = feature["properties"]["international_schools"]
      # Bundle them to send to methods
      one_ldk = { val: ward_1ldk, max: max_1ldk, min: min_1ldk }
      two_ldk = { val: ward_2ldk, max: max_2ldk, min: min_2ldk }
      three_ldk = { val: ward_3ldk, max: max_3ldk, min: min_3ldk }
      safety = { val: ward_safety, max: max_safety, min: min_safety }
      schools = { val: ward_schools, max: max_school_count, min: min_school_count }

      # 1ldk + safety
      feature["properties"]["one_ldk_sort_color"] = normalize(one_ldk)
      feature["properties"]["one_ldk_safety_sort_color"] = normalize(one_ldk, safety)
      # 2ldk + safety
      feature["properties"]["two_ldk_sort_color"] = normalize(two_ldk)
      feature["properties"]["two_ldk_safety_sort_color"] = normalize(two_ldk, safety)

      # 3ldk + safety
      feature["properties"]["three_ldk_sort_color"] = normalize(three_ldk)
      feature["properties"]["three_ldk_safety_sort_color"] = normalize(three_ldk, safety)
      # safety and school count

      feature["properties"]["safety_sort_color"] = normalize(safety)
      if ward_schools.zero?
        feature["properties"]["international_schools_sort_color"] = @no_schools
        feature["properties"]["one_ldk_international_schools_sort_color"] = @no_schools
        feature["properties"]["two_ldk_international_schools_sort_color"] = @no_schools
        feature["properties"]["three_ldk_international_schools_sort_color"] = @no_schools
      else
        feature["properties"]["international_schools_sort_color"] = normalize(schools)
        feature["properties"]["one_ldk_international_schools_sort_color"] = normalize(one_ldk, schools)
        feature["properties"]["two_ldk_international_schools_sort_color"] = normalize(two_ldk, schools)
        feature["properties"]["three_ldk_international_schools_sort_color"] = normalize(three_ldk, schools)
      end
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
    red = @max_r - ((@max_r - @min_r) * normalized_val)
    green = @max_g - ((@max_g - @min_g) * normalized_val)
    blue = @max_b - ((@max_b - @min_b) * normalized_val)
    "rgb(#{red.round.abs},#{green.round.abs},#{blue.round.abs})"
  end
end
