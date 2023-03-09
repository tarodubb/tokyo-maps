require "json"
require "faker"
require "securerandom"
require "open-uri"
require_relative "../app/functions/get_average"
require_relative "scraper.rb"
require_relative "../app/functions/normalize"

p "Descroying messages"
Message.destroy_all

p "Destroying Wards"
Ward.destroy_all

p "Destroying Users"
User.destroy_all

wards = {
  "chiyoda ku" => "千代田区",
  "chuo ku" => "中央区",
  "minato ku" => "港区",
  "shinjuku ku" => "新宿区",
  "bunkyo ku" => "文京区",
  "taito ku" => "台東区",
  "sumida ku" => "墨田区",
  "koto ku" => "江東区",
  "shinagawa ku" => "品川区",
  "meguro ku" => "目黒区",
  "ota ku" => "大田区",
  "setagaya ku" => "世田谷区",
  "shibuya ku" => "渋谷区",
  "nakano ku" => "中野区",
  "suginami ku" => "杉並区",
  "toshima ku" => "豊島区",
  "kita ku" => "北区",
  "arakawa ku" => "荒川区",
  "itabashi ku" => "板橋区",
  "nerima ku" => "練馬区",
  "adachi ku" => "足立区",
  "katsushika ku" => "葛飾区",
  "edogawa ku" => "江戸川区",
}

# Join and parse wards dataset
wards_file_path = File.join(File.dirname(__FILE__), "./wards.json")
wards_info = File.read(wards_file_path)
wards_parsed_json = JSON.parse(wards_info)


# Parse the outline geodata of each tokyo ward
wards_geojson = File.read("public/tokyo.geojson")
wards_parsed_geojson = JSON.parse(wards_geojson)

# Parse the lat and long of each ward geodata
labels_geojson = File.read("public/labels.geojson")
labels_parsed_geojson = JSON.parse(labels_geojson)

wards.each do |en_name, jp_name|
  ward_scrape_name = en_name.downcase.split(" ", -1)[0] + "-ku"
  schools = scrape_schools(ward_scrape_name)
  temp_ward = Ward.new(name: en_name, school_info: schools)
  wards_parsed_json["tokyo_wards"].each do |parsed_ward|
    if parsed_ward["name"].downcase + " ku" == en_name
      temp_ward.population = parsed_ward["population"].to_i
      temp_ward.population_density = parsed_ward["population_density"].to_i
      temp_ward.one_ldk_avg_rent = parsed_ward["one_ldk_avg_rent"]
      temp_ward.two_ldk_avg_rent = parsed_ward["two_ldk_avg_rent"]
      temp_ward.three_ldk_avg_rent = parsed_ward["three_ldk_avg_rent"]
      temp_ward.summary = parsed_ward["summary"]
      temp_ward.summary = parsed_ward["summary"]
      temp_ward.points_of_interest = parsed_ward["points_of_interest"]
      temp_ward.transportation_rating = parsed_ward["transportation_rating"]
      temp_ward.shopping_rating = parsed_ward["shopping_rating"]
      temp_ward.entertainment_rating = parsed_ward["entertainment_rating"]
      temp_ward.security_rating = parsed_ward["security_rating"]
      temp_ward.natural_disaster_safety_rating = parsed_ward["natural_disaster_safety_rating"]
      temp_ward.housing_cost_satisfaction_rating = parsed_ward["housing_cost_satisfaction_rating"]
      # add saftey percentages to wards
      # adding photos from google search results to each point of interest
      temp_ward.historical_significance = parsed_ward["historical_significance"]
      temp_ward.safety = parsed_ward["safety"]
      temp_ward.rent_url = parsed_ward["rent_url"]
      temp_ward.flag = parsed_ward["flag"]
    end
  end

  # Update the tokyo geojson with new rent information to be used for sorting.
  wards_parsed_geojson["features"].each do |feature|
    if feature["properties"]["ward_en"]&.downcase == temp_ward.name
      feature["properties"]["one_ldk"] = temp_ward.one_ldk_avg_rent
      feature["properties"]["two_ldk"] = temp_ward.two_ldk_avg_rent
      feature["properties"]["three_ldk"] = temp_ward.three_ldk_avg_rent
      feature["properties"]["international_schools"] = temp_ward[:school_info].count
      # feature["properties"]["transportation_rating"] = temp_ward.transportation_rating
      # feature["properties"]["shopping_rating"] = temp_ward.shopping_rating
      # feature["properties"]["entertainment_rating"] = temp_ward.entertainment_rating
      # feature["properties"]["natural_disaster_safety_rating"] = temp_ward.natural_disaster_safety_rating
      feature["properties"]["safety"] = temp_ward.safety.to_f
    end
  end

  # Set lat and long for each ward
  labels_parsed_geojson["features"].each do |feature|
    if feature["properties"]["ward_en"].downcase + " ku" == temp_ward.name
      temp_ward.longitude = feature["geometry"]["coordinates"][0]
      temp_ward.latitude = feature["geometry"]["coordinates"][1]
    end
  end
  temp_ward.save
end
# Changes the tokyo geojson with new rent data.
File.open('public/tokyo.geojson', 'w') do |file|
  file.write(JSON.pretty_generate(wards_parsed_geojson))
end

# User seeding
p "Seeding users now..."
# Function to generate a random string of lowercase letters and digits
def generate_password
  SecureRandom.alphanumeric(8)
end

# Generate 10 users
10.times do
  first_name = Faker::Name.unique.first_name
  last_name = Faker::Name.last_name
  email = "#{first_name.downcase}.#{last_name.downcase}@yahoo.com"
  password = generate_password
  username = "#{first_name.downcase}.#{last_name.downcase}"
  ward = "Shibuya"
  address = "#{ward}, Tokyo"
  user = User.create(
    first_name: first_name,
    last_name: last_name,
    email: email,
    password: password,
    username: username,
    address: address,
    avatar: "/app/assets/images/dog-costume-banana-slug-kitai.jpg"
  )
  p user
end

get_max_avg = GetAverage.get_max_avg
get_min_avg = GetAverage.get_min_avg
ColorSet.color_set(get_max_avg, get_min_avg)
# ExtrusionHeight.extrude_height(get_max_avg, get_min_avg, get_safety)
# Normalize.normalize_data # THIS NEEDS TO GO BELOW ColorSet. It acceses values written into the geojson after the extrude function is done
p "Seeding of the users has been successfully completed"

shibuya = Ward.find_by(name: "shibuya ku")
Review.create!(rating: 4, content: "Living in Shibuya can be exciting, as it provides easy access to other parts of the city, neighboring towns and cities, and is a great place to socialize and meet new people. Additionally, Shibuya is a diverse and welcoming community due to its many international residents. However, living in Shibuya has some downsides, including noise and traffic, particularly during rush hour, and the high cost of living. Housing in Shibuya can also be quite expensive compared to other parts of Tokyo. Overall, if you value convenience, excitement, and a lively atmosphere, Shibuya may be the perfect place for you, but it is essential to consider potential drawbacks before making the decision to move there.", user: User.all.sample, ward: shibuya)
Review.create!(rating: 2, content: "It was a very frustrating experience because of lack of cleanliness. The area is known for its busy streets and bustling nightlife, but this comes at the cost of cleanliness. Trash and litter are common sights, and the streets and sidewalks are often dirty and unkempt. This can be especially problematic for residents who value cleanliness and hygiene. Overall, the lack of cleanliness in Shibuya can detract from the otherwise exciting and vibrant atmosphere, making it a less than desirable place to live.", user: User.first, ward: shibuya)
koto = Ward.find_by(name: "koto ku")
Review.create!(rating: 5, content: "Koto is a hidden gem in Tokyo. The area is quiet, peaceful, and has a lot of charm. There are plenty of parks and green spaces to enjoy, and the community is tight-knit and welcoming. However, the area can be a bit isolated, and the transportation options are limited.", user: User.all.sample, ward: koto)
Review.create!(rating: 4, content: "Living in Koto is like living in a small town in the heart of Tokyo. The area is quiet, safe, and has a lot of character. The community is friendly, and there are plenty of green spaces to enjoy. However, the area can be a bit isolated, and the transportation options are limited, which can be a challenge at times. Overall, I love living in Koto and wouldn't want to live anywhere else.", user: User.all.sample, ward: koto)
shinjuku = Ward.find_by(name: "shinjuku ku")
Review.create!(rating: 3, content: "As a resident of Shinjuku, I love the convenience of the area. With several train and subway lines, it's easy to get around Tokyo. There are plenty of restaurants, bars, and shops, and the nightlife is fantastic. However, the crowds and noise can be overwhelming, and housing can be expensive.", user: User.all.sample, ward: shinjuku)
Review.create!(rating: 4, content: "Living in Shinjuku is an exciting experience. The area is always buzzing, and there's always something to do. The abundance of transportation options is a huge plus, and there's an endless selection of restaurants and bars to explore. However, it can be challenging to find affordable housing, and the crowds can be overwhelming at times. Overall, I love living in Shinjuku, but it's not for everyone.", user: User.all.sample, ward: shinjuku)
minato = Ward.find_by(name: "minato ku")
Review.create!(rating: 4, content: "Living in Minato is a fantastic experience. The area is clean, safe, and has a lot to offer. The neighborhood is full of beautiful parks and gardens, and there are plenty of high-end shops and restaurants. However, the cost of living can be high, and the pace of life can be slow.", user: User.all.sample, ward: minato)
Review.create!(rating: 4, content: "Minato is a peaceful oasis in the heart of Tokyo. The area is clean, safe, and well-maintained. There are plenty of green spaces to enjoy, and the selection of high-end shops and restaurants is unbeatable. However, the cost of living can be a drawback, and the area can be quiet at times. Overall, I love living in Minato and wouldn't want to live anywhere else.", user: User.all.sample, ward: minato)
