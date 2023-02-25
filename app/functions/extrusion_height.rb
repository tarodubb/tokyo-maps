require "json"

class ExtrusionHeight
  def self.get_max_avg
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

  def self.get_min_avg
    wards_geojson = File.read("public/tokyo.geojson")
    wards_parsed_geojson = JSON.parse(wards_geojson)
    min_1ldk = nil
    min_2ldk = nil
    min_3ldk = nil
    wards_parsed_geojson["features"].each do |feature|
      # Find highest value of each rent average from geojson file
      if min_1ldk.nil? || feature["properties"]["one_ldk_sort_height"] < min_1ldk
        min_1ldk = feature["properties"]["one_ldk_sort_height"]
      end
      if min_2ldk.nil? || feature["properties"]["two_ldk_sort_height"] < min_2ldk
        min_2ldk = feature["properties"]["two_ldk_sort_height"]
      end
      if min_3ldk.nil? || feature["properties"]["three_ldk_sort_height"] < min_3ldk
        min_3ldk = feature["properties"]["three_ldk_sort_height"]
      end
    end
    # Set normalized height factor for each category
    [min_1ldk, min_2ldk, min_3ldk]
  end

  def self.get_safety
    wards_geojson = File.read("public/tokyo.geojson")
    wards_parsed_geojson = JSON.parse(wards_geojson)
    max_safety = nil
    min_safety = nil
    wards_parsed_geojson["features"].each do |feature|
      # Find highest value of each rent average from geojson file
      max_safety = feature["properties"]["safety"] if max_safety.nil? || feature["properties"]["safety"] > max_safety
      min_safety = feature["properties"]["safety"] if min_safety.nil? || feature["properties"]["safety"] < min_safety
      # Set normalized height factor for each category
    end
    [max_safety, min_safety]
  end

  def self.extrude_height(avg_rent_max_array, avg_rent_min_array, safety_array)
    h = 5000.0
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
      # Multiply each avg by height factor category
      feature["properties"]["one_ldk_sort_height"] =
        h * ((feature["properties"]["one_ldk_sort_height"] - min_1ldk).fdiv(max_1ldk - min_1ldk))
      feature["properties"]["two_ldk_sort_height"] =
        h * ((feature["properties"]["two_ldk_sort_height"] - min_2ldk).fdiv(max_2ldk - min_2ldk))
      feature["properties"]["three_ldk_sort_height"] =
        h * ((feature["properties"]["three_ldk_sort_height"] - min_3ldk).fdiv(max_3ldk - min_3ldk))
      feature["properties"]["safety"] = h * ((feature["properties"]["safety"] - min_safety).fdiv(max_safety - min_safety))
    end
    File.write('public/tokyo.geojson', JSON.pretty_generate(wards_parsed_geojson))
  end
end
