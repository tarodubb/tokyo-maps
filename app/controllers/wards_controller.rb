require 'open-uri'


class WardsController < ApplicationController
  def index
    @wards = Ward.all
  end

  def show
    @ward = Ward.find(params[:id])
    # Cant change area to singular or it breaks the whole map_show_controller
    @areas = {
      name: @ward.name,
      id: @ward.id,
      code: @ward.ward_code,
      one_ldk: @ward.one_ldk_avg_rent,
      two_ldk: @ward.two_ldk_avg_rent,
      three_ldk: @ward.three_ldk_avg_rent,
      latitude: @ward.latitude,
      longitude: @ward.longitude
    }
    @review = Review.new
  end

  def scraper
    rent_url = "https://apartments.gaijinpot.com/en/rent/listing?prefecture=JP-13&city=chiyoda-ku&district=&min_price=&max_price=&min_meter=&rooms=15&distance_station=&agent_id=&building_type=&building_age=&updated_within=&transaction_type=&order=&search=Search"
    # url = "https://www.lewagon.com"
    html = URI.open(rent_url)
    @doc = Nokogiri::HTML.parse(html)
    bodies = @doc.search(".listing-body").first(3)
    @cards_info = []
    bodies.each do |item|
      @cards_info << item.search(".listing-item").map {|i| i.text.strip}
    end
    # @span = @titles.search(".text-semi-strong")[0].text.strip
    # @array = []
    # @titles.each do |listing|
    #   @array << listing.text.strip
    # end
  end
end
