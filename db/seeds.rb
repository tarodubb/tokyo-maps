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
