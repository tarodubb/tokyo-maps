require_relative "./extrusion_height"

def color_set
  # Set main color (The higher the number the darker the color)
  red = 59
  green = 57
  blue = 208

  lower_red = 1
  lower_green = 1
  lower_blue = 1
  # Set hover color
  hover_red = 255
  hover_green = 255
  hover_blue = 255

  max_avg = get_max_avg
  min_avg = get_min_avg

  max_color_r = red / max_avg[0]
  max_color_g = green / max_avg[0]
  max_color_b = blue / max_avg[0]

  min_color_r = lower_red / min_avg[0]
  min_color_g = lower_green / min_avg[0]
  min_color_b = lower_blue / min_avg[0]



  wards_geojson = File.read("public/tokyo.geojson")
  wards_parsed_geojson = JSON.parse(wards_geojson)
  wards_parsed_geojson["features"].each do |feature|
    ward_1ldk_height = feature["properties"]["one_ldk_sort_height"]
    red_color_dif = (ward_1ldk_height * max_color_r)
    green_color_dif = (ward_1ldk_height * max_color_g)
    blue_color_dif = (ward_1ldk_height * max_color_b)

    # p base_color.to_rgb
    feature["properties"]["base-color"] = "rgb(#{red},#{green},#{blue})"
    feature["properties"]["base-color"] = "rgb(#{red - (red_color_dif).round},#{green - (green_color_dif).round},#{blue - (blue_color_dif).round})"
    feature["properties"]["hover-color"] = "rgb(#{hover_red},#{hover_green},#{hover_blue})"
  end
  File.write('public/tokyo.geojson', JSON.pretty_generate(wards_parsed_geojson))
end
color_set
