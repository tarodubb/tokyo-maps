require "json"

def get_max_avg
  wards_geojson = File.read("public/tokyo.geojson")
  wards_parsed_geojson = JSON.parse(wards_geojson)
  max_1ldk = 0
  max_2ldk = 0
  max_3ldk = 0
  wards_parsed_geojson["features"].each do |feature|
    # Find highest value of each rent average from geojson file
    max_1ldk = feature["properties"]["one_ldk_sort_height"] if feature["properties"]["one_ldk_sort_height"] > max_1ldk
    max_2ldk = feature["properties"]["two_ldk_sort_height"] if feature["properties"]["two_ldk_sort_height"] > max_2ldk
    if feature["properties"]["three_ldk_sort_height"] > max_3ldk
      max_3ldk = feature["properties"]["three_ldk_sort_height"]
    end
  end
  # Set normalized height factor for each category
  [max_1ldk, max_2ldk, max_3ldk]
end

def get_min_avg
  wards_geojson = File.read("public/tokyo.geojson")
  wards_parsed_geojson = JSON.parse(wards_geojson)
  min_1ldk = nil
  min_2ldk = nil
  min_3ldk = nil
  wards_parsed_geojson["features"].each do |feature|
    # Find highest value of each rent average from geojson file
    if min_1ldk == nil || feature["properties"]["one_ldk_sort_height"] < min_1ldk
      min_1ldk = feature["properties"]["one_ldk_sort_height"]
    end
    if min_2ldk == nil || feature["properties"]["two_ldk_sort_height"] < min_2ldk
      min_2ldk = feature["properties"]["two_ldk_sort_height"]
    end
    if min_3ldk == nil || feature["properties"]["three_ldk_sort_height"] < min_3ldk
      min_3ldk = feature["properties"]["three_ldk_sort_height"]
    end
  end
  # Set normalized height factor for each category
  [min_1ldk, min_2ldk, min_3ldk]
end

def extrude_height(avg_rent_max_array)
  h = 5000
  wards_geojson = File.read("public/tokyo.geojson")
  wards_parsed_geojson = JSON.parse(wards_geojson)
  wards_parsed_geojson["features"].each do |feature|
    # Multiply each avg by height factor category
    feature["properties"]["one_ldk_sort_height"] =
      avg_rent_max_array[0] * h / feature["properties"]["one_ldk_sort_height"]
    feature["properties"]["two_ldk_sort_height"] =
      avg_rent_max_array[1] * h / feature["properties"]["two_ldk_sort_height"]
    feature["properties"]["three_ldk_sort_height"] =
      avg_rent_max_array[2] * h / feature["properties"]["three_ldk_sort_height"]
  end
  File.write('public/tokyo.geojson', JSON.pretty_generate(wards_parsed_geojson))
end
