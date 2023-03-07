require "json"

class GetAverage
  def self.get_max_avg
    wards_geojson = File.read("public/tokyo.geojson")
    wards_parsed_geojson = JSON.parse(wards_geojson)
    category_max = {}
    wards_parsed_geojson["features"].each do |feature|
      # Find highest value of each rent average from geojson file

      if category_max[:oneldk].nil? || feature["properties"]["one_ldk"] > category_max[:oneldk]
        category_max[:oneldk] =
          feature["properties"]["one_ldk"]
      end
      if category_max[:twoldk].nil? || feature["properties"]["two_ldk"] > category_max[:twoldk]
        category_max[:twoldk] =
          feature["properties"]["two_ldk"]
      end
      if category_max[:threeldk].nil? || feature["properties"]["three_ldk"] > category_max[:threeldk]
        category_max[:threeldk] = feature["properties"]["three_ldk"]
      end
      if category_max[:international_schools].nil? || feature["properties"]["international_schools"] > category_max[:international_schools]
        category_max[:international_schools] = feature["properties"]["international_schools"]
      end
      # if category_max[:shopping_rating].nil? || feature["properties"]["shopping_rating"] > category_max[:shopping_rating]
      #   category_max[:shopping_rating] = feature["properties"]["shopping_rating"]
      # end
      # if category_max[:entertainment_rating].nil? || feature["properties"]["entertainment_rating"] > category_max[:entertainment_rating]
      #   category_max[:entertainment_rating] = feature["properties"]["entertainment_rating"]
      # end
      # if category_max[:natural_disaster_safety_rating].nil? || feature["properties"]["natural_disaster_safety_rating"] > category_max[:natural_disaster_safety_rating]
      #   category_max[:natural_disaster_safety_rating] = feature["properties"]["natural_disaster_safety_rating"]
      # end
      if category_max[:safety].nil? || feature["properties"]["safety"] > category_max[:safety]
        category_max[:safety] = feature["properties"]["safety"]
      end
    end
    category_max
  end

  def self.get_min_avg
    wards_geojson = File.read("public/tokyo.geojson")
    wards_parsed_geojson = JSON.parse(wards_geojson)
    category_min = {}
    wards_parsed_geojson["features"].each do |feature|
      # Find lowest value of each category from geojson file

      if category_min[:oneldk].nil? || feature["properties"]["one_ldk"] < category_min[:oneldk]
        category_min[:oneldk] =
          feature["properties"]["one_ldk"]
      end
      if category_min[:twoldk].nil? || feature["properties"]["two_ldk"] < category_min[:twoldk]
        category_min[:twoldk] =
          feature["properties"]["two_ldk"]
      end
      if category_min[:threeldk].nil? || feature["properties"]["three_ldk"] < category_min[:threeldk]
        category_min[:threeldk] = feature["properties"]["three_ldk"]
      end
      if category_min[:international_schools].nil? || feature["properties"]["international_schools"] < category_min[:international_schools]
        category_min[:international_schools] = feature["properties"]["international_schools"]
      end
      # if category_min[:shopping_rating].nil? || feature["properties"]["shopping_rating"] < category_min[:shopping_rating]
      #   category_min[:shopping_rating] = feature["properties"]["shopping_rating"]
      # end
      # if category_min[:entertainment_rating].nil? || feature["properties"]["entertainment_rating"] < category_min[:entertainment_rating]
      #   category_min[:entertainment_rating] = feature["properties"]["entertainment_rating"]
      # end
      # if category_min[:natural_disaster_safety_rating].nil? || feature["properties"]["natural_disaster_safety_rating"] < category_min[:natural_disaster_safety_rating]
      #   category_min[:natural_disaster_safety_rating] = feature["properties"]["natural_disaster_safety_rating"]
      # end
      if category_min[:safety].nil? || feature["properties"]["safety"] < category_min[:safety]
        category_min[:safety] = feature["properties"]["safety"]
      end
    end
    category_min
  end

  # def self.extrude_height(avg_rent_max_array, avg_rent_min_array, safety_array)
  #   h = 5000.0
  #   min_1ldk = avg_rent_min_array[0]
  #   min_2ldk = avg_rent_min_array[1]
  #   min_3ldk = avg_rent_min_array[2]

  #   max_1ldk = avg_rent_max_array[0]
  #   max_2ldk = avg_rent_max_array[1]
  #   max_3ldk = avg_rent_max_array[2]

  #   max_safety = safety_array[0]
  #   min_safety = safety_array[1]

  #   wards_geojson = File.read("public/tokyo.geojson")
  #   wards_parsed_geojson = JSON.parse(wards_geojson)
  #   wards_parsed_geojson["features"].each do |feature|
  #     # Multiply each avg by height factor category
  #     feature["properties"]["one_ldk_sort_height"] =
  #       h * ((feature["properties"]["one_ldk_sort_height"] - min_1ldk).fdiv(max_1ldk - min_1ldk))
  #     feature["properties"]["two_ldk_sort_height"] =
  #       h * ((feature["properties"]["two_ldk_sort_height"] - min_2ldk).fdiv(max_2ldk - min_2ldk))
  #     feature["properties"]["three_ldk_sort_height"] =
  #       h * ((feature["properties"]["three_ldk_sort_height"] - min_3ldk).fdiv(max_3ldk - min_3ldk))
  #     feature["properties"]["safety"] = h * ((feature["properties"]["safety"] - min_safety).fdiv(max_safety - min_safety))
  #   end
  #   File.write('public/tokyo.geojson', JSON.pretty_generate(wards_parsed_geojson))
  # end
end
