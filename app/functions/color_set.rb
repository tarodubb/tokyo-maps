require_relative "./extrusion_height"
class ColorSet
  def self.color_set(category)
    # Set main color (The higher the number the darker the color)
    max_red = 59
    max_green = 57
    max_blue = 208

    lower_red = 1
    lower_green = 1
    lower_blue = 1
    # Set hover color
    hover_red = 255
    hover_green = 255
    hover_blue = 255


    wards_geojson = File.read("public/tokyo.geojson")
    wards_parsed_geojson = JSON.parse(wards_geojson)
    wards_parsed_geojson["features"].each do |feature|
      ward_1ldk_height = feature["properties"]["one_ldk_sort_height"]
      red_color_dif = (ward_1ldk_height * max_color_r)
      green_color_dif = (ward_1ldk_height * max_color_g)
      blue_color_dif = (ward_1ldk_height * max_color_b)

      # p base_color.to_rgb
      feature["properties"]["base-color"] = "rgb(#{red},#{green},#{blue})"
      feature["properties"]["base-color"] =
        "rgb(#{red - red_color_dif.round},#{green - green_color_dif.round},#{blue - blue_color_dif.round})"
      feature["properties"]["hover-color"] = "rgb(#{hover_red},#{hover_green},#{hover_blue})"
    end
    File.write('public/tokyo.geojson', JSON.pretty_generate(wards_parsed_geojson))
  end
end
