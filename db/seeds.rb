# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
Ward.destroy_all
p "Destroyed all wards"
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

wards.each do |ward|
  Ward.create(name: ward)
end

p "Seeding complete!"

max_ward = Ward.create(name: "Max",
            summary: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer vitae maximus sem. Integer quam
                      turpis, pulvinar sit amet gravida at, consequat eu urna. Duis in mauris in risus commodo commodo a
                      sed lacus.Maecenas lacinia congue gravida. Quisque enim nisi, fringilla in eleifend sed, euismod ut justo.
                      Integer tellus nibh, volutpat a lorem faucibus, faucibus mattis magna. Sed turpis orci, elementum eget aliquet ac,
                      vestibulum id nibh. Donec mattis leo in ornare vulputate. Sed venenatis metus diam, at ultrices nunc venenatis sed. Integer
                      at elit nec odio feugiat egestas at sit amet turpis. Sed ex quam, lobortis in velit id, bibendum rutrum turpis.
                      Ut porttitor ligula lorem, nec imperdiet dolor semper quis.",
            flag: "doggo",
            one_ldk_avg_rent: 1,
            two_ldk_avg_rent: 2,
            three_ldk_avg_rent: 3,
            safety: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer vitae maximus sem. Integer quam
                      turpis, pulvinar sit amet gravida at, consequat eu urna. Duis in mauris in risus commodo commodo a
                      sed lacus.Maecenas lacinia congue gravida. Quisque enim nisi, fringilla in eleifend sed, euismod ut justo.
                      Integer tellus nibh, volutpat a lorem faucibus, faucibus mattis magna. Sed turpis orci, elementum eget aliquet ac,
                      vestibulum id nibh. Donec mattis leo in ornare vulputate. Sed venenatis metus diam, at ultrices nunc venenatis sed. Integer
                      at elit nec odio feugiat egestas at sit amet turpis. Sed ex quam, lobortis in velit id, bibendum rutrum turpis.
                      Ut porttitor ligula lorem, nec imperdiet dolor semper quis.",
            school_ratings: 10,
            population: 10000,
            population_density: 1234)

max_ward.save!

p "Max seeded"
