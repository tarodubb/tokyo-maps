require "json"
require "faker"
require "securerandom"
require "open-uri"

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
  temp_ward = Ward.new(name: en_name)

  wards_parsed_json["tokyo_wards"].each do |parsed_ward|
    if parsed_ward["name"].downcase + " ku" == en_name
      temp_ward.population = parsed_ward["population"].to_i
      temp_ward.population_density = parsed_ward["population_density"].to_i
      temp_ward.one_ldk_avg_rent = rand(500..2000)
      temp_ward.two_ldk_avg_rent = parsed_ward["two_ldk_avg_rent"]
      temp_ward.three_ldk_avg_rent = parsed_ward["three_ldk_avg_rent"]
      temp_ward.summary = parsed_ward["summary"]
      temp_ward.points_of_interest = parsed_ward["points_of_interest"]
      # adding photos from google search results to each point of interest
      options = {}
      options[:searchType] = "image"
      options[:imgSize] = "img_size_medium"
      temp_ward.points_of_interest.each do |point|
        item = GoogleCustomSearchApi.search(point, options).items[0]
        if item != nil
          link = item.link
          file = URI.open(link)
          temp_ward.photos.attach(io: file, filename: "#{point[0, 5]}.jpg", content_type: "image/jpg")
        end
      end
      temp_ward.historical_significance = parsed_ward["historical_significance"]
      temp_ward.flag = "https://upload.wikimedia.org/wikipedia/commons/thumb/b/be/Flag_of_#{parsed_ward["name"]}a%2C_Tokyo.svg/1200px-Flag_of_Edogawa%2C_Tokyo.svg.png"
    end
  end

  # Update the tokyo geojson with new rent information to be used for sorting.
  wards_parsed_geojson["features"].each do |feature|
    if feature["properties"]["ward_en"]&.downcase == temp_ward.name
      feature["properties"]["one_ldk_sort_height"] = temp_ward.one_ldk_avg_rent
      feature["properties"]["two_ldk_sort_height"] = temp_ward.two_ldk_avg_rent
      feature["properties"]["three_ldk_sort_height"] = temp_ward.three_ldk_avg_rent
    end
  end
  p "Setting lat and long values for ward"
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
    avatar: "/app/assets/images/dog-costume-banana-slug-kitai.jpg",
  )
  p user
end

p "Seeding of the users has been successfully completed"
