require "open-uri"
require "nokogiri"

ku = "shinagawa-ku"


def scrape_schools(ku)
  puts ku
  url = "https://www.realestate-tokyo.com/living-in-tokyo/international-schools/#{ku}/"

  schools = []
  begin
  html_file = URI.open(url).read
  rescue OpenURI::HTTPError => ex
    puts "No schools in this ward"
  end
  html_doc = Nokogiri::HTML.parse(html_file)


  html_doc.search(".row.info-card_school").each do |element|
    name = element.search("h3").text.strip
    website = element.search("a").first&.[]("href").to_s.strip
    phone = element.search(".fa-phone").text.strip
    address = element.search(".fa-map-marker").text.strip
    access = element.search(".fa-subway").text.strip

    schools << {
      name: name,
      website: website,
      phone: phone,
      address: address,
      access: access
    }
  end
  return schools
end

# schools = scrape_schools(ku)
# schools.each do |school|
#   # puts "test"
#   # puts school
#   puts school[:name]
#   puts school[:website]
#   puts school[:phone]
#   puts school[:address]
#   puts school[:access]
# end


# 1. modify scrape_school to return hash with all info
# 2. require relative scraper.rb in seed.rb file
# 3. call scrape school and store the hash it returns in the ward school info atribute
