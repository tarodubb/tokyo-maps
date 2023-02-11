require "json"
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# Ward.destroy_all
# p "Destroyed all wards"
Ward.destroy_all

file_path = File.join(File.dirname(__FILE__), "./tokyo.geojson")
parsed_geo_json = JSON.parse(File.read(file_path))
p parsed_geo_json["features"][0]["properties"]
# p parsed_geo_json["features"][0]["geometry"]["coordinates"]
wards = {
  "chiyoda ku" => "千代田区",
  "chuo ku" => "中央区",
  "minato ku" => "港区",
  "shinju ku" => "新宿区",
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
# p "Seeding complete!"
