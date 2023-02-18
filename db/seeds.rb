require "json"
require "faker"
require 'securerandom'
p "Destroying Wards"
Ward.destroy_all

p "Destroying Users"
User.destroy_all

wards = {
  "chiyoda" => "千代田区",
  "chuo" => "中央区",
  "minato" => "港区",
  "shinj" => "新宿区",
  "bunkyo" => "文京区",
  "taito" => "台東区",
  "sumida" => "墨田区",
  "koto" => "江東区",
  "shinagawa" => "品川区",
  "meguro" => "目黒区",
  "ota" => "大田区",
  "setagaya" => "世田谷区",
  "shibuya" => "渋谷区",
  "nakano" => "中野区",
  "suginami" => "杉並区",
  "toshima" => "豊島区",
  "kita" => "北区",
  "arakawa" => "荒川区",
  "itabashi" => "板橋区",
  "nerima" => "練馬区",
  "adachi" => "足立区",
  "katsushika" => "葛飾区",
  "edogawa" => "江戸川区"
}


file_path = File.join(File.dirname(__FILE__), "./tokyo.geojson")
parsed_geo_json = JSON.parse(File.read(file_path))
p parsed_geo_json["features"][0]["properties"]
# p parsed_geo_json["features"][0]["geometry"]["coordinates"]
wards_file_path = File.join(File.dirname(__FILE__), "./wards.json")
wards_info = File.read(wards_file_path)
wards_parsed_json = JSON.parse(wards_info)

wards.each do |en_name, jp_name|
  temp_ward = Ward.new(name: en_name)
  parsed_geo_json["features"].each do |feature|
    if feature["properties"]["ward_en"]&.downcase == en_name
      temp_ward.geojson = feature["geometry"].to_json
    end
  end
  wards_parsed_json["tokyo_wards"].each do |parsed_ward|
   if parsed_ward["name"].downcase == en_name
    temp_ward.population = parsed_ward["population"].to_i
    temp_ward.population_density = parsed_ward["population_density"].to_i
    temp_ward.one_ldk_avg_rent = parsed_ward["one_ldk_avg_rent"]
    temp_ward.two_ldk_avg_rent = parsed_ward["two_ldk_avg_rent"]
    temp_ward.three_ldk_avg_rent = parsed_ward["three_ldk_avg_rent"]
    temp_ward.summary = parsed_ward["summary"]
    temp_ward.points_of_interest = parsed_ward["points_of_interest"]
    temp_ward.historical_significance = parsed_ward["historical_significance"]
    temp_ward.flag = parsed_ward["flag"]
   end
  end
  temp_ward.save
end
# json parsing for ward infos

p "Seeding complete!"


max_ward = Ward.create(name: "Shibuya",
            summary: "Shibuya is a bustling ward located in the southwestern part of Tokyo, Japan. It is known as a major entertainment and commercial hub, offering a mix of traditional and modern attractions that draw visitors from all over the world. The ward is particularly famous for its trendy fashion stores, shopping centers, restaurants, and nightlife, making it a popular destination for young people and fashion enthusiasts.
            One of the most iconic features of Shibuya is the Shibuya Crossing, a busy intersection that is said to be the busiest in the world. This intersection is surrounded by neon lights and huge billboards, making it a popular spot for photographers and tourists. Other popular attractions in Shibuya include the Meiji Shrine, a Shinto shrine dedicated to Emperor Meiji and Empress Shoken; the Cat Street, a fashionable street with designer shops, cafes, and galleries; and the Harajuku neighborhood, a center for youth culture and fashion.
            Despite its lively atmosphere, Shibuya is also home to many parks and green spaces, such as Yoyogi Park, a popular spot for picnics and outdoor events. The ward also boasts a high quality of life, with excellent public transportation and easy access to other parts of Tokyo.
            Shibuya has a relatively low crime rate, but some areas near nightlife spots can be crowded and prone to pickpocketing, so visitors should take appropriate precautions. The average rent price in Shibuya is relatively high, at around 200,000 yen per month, reflecting the area’s popularity and desirability.
            Overall, Shibuya offers a unique blend of modern and traditional Japanese culture, making it a must-visit destination for anyone visiting Tokyo.",
            flag: "shibuya flag",
            one_ldk_avg_rent: 1,
            two_ldk_avg_rent: 2,
            three_ldk_avg_rent: 3,
            safety: "Shibuya is a relatively safe area, but some areas near nightlife spots can be crowded and prone to pickpocketing.",
            school_ratings: 10,
            population: 227850,
            population_density: 15000)

max_ward.save!
p "Max seeded"

# User seeding
p "Seeding users"
# Function to generate a random string of lowercase letters and digits
def generate_password
  SecureRandom.alphanumeric(8)
end
# Generate 100 users
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
