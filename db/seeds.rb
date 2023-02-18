require "json"
require "faker"
require 'securerandom'
# I18n.reload!
p "Destroying Wards"
Ward.destroy_all
p "Destroying Users"
User.destroy_all

file_path = File.join(File.dirname(__FILE__), "./tokyo.geojson")
parsed_geo_json = JSON.parse(File.read(file_path))
p parsed_geo_json["features"][0]["properties"]
# p parsed_geo_json["features"][0]["geometry"]["coordinates"]
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
  "edogawa ku" => "江戸川区"
}

wards.each do |en_name, jp_name|
  temp_ward = Ward.new(name: en_name)
  parsed_geo_json["features"].each do |feature|
    if feature["properties"]["ward_en"]&.downcase == en_name
      temp_ward.geojson = feature["geometry"].to_json
    end
  end
  temp_ward.save
end

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
    address: address
  )
  p user
end
