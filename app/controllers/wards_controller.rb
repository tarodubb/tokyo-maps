require "httparty"

class WardsController < ApplicationController
  def index
    @wards = Ward.all
  end

  def show
    @ward = Ward.find(params[:id])
    @air_quality_data = get_air_quality_data(@ward.latitude, @ward.longitude)
    @air_quality_color = get_air_quality_color(@air_quality_data['list'][0]['main']['aqi'])
    @air_quality_description = get_air_quality_description(@air_quality_data['list'][0]['main']['aqi'])
    # Cant change area to singular or it breaks the whole map_show_controller
    @areas = {
      name: @ward.name,
      id: @ward.id,
      code: @ward.ward_code,
      one_ldk: @ward.one_ldk_avg_rent,
      two_ldk: @ward.two_ldk_avg_rent,
      three_ldk: @ward.three_ldk_avg_rent,
      latitude: @ward.latitude,
      longitude: @ward.longitude,
    }
    @review = Review.new
    @message = Message.new
  end
end

private

def get_air_quality_data(latitude, longitude)
  response = HTTParty.get("http://api.openweathermap.org/data/2.5/air_pollution?lat=#{@ward.latitude}&lon=#{@ward.longitude}&appid=d0a9c6891581954c7fe9d124e4c405a2")
  if response.success?
    @air_quality_data = response.parsed_response
  else
    @air_quality_data = nil
  end
end

def get_air_quality_color(aqi)
  case aqi
  when 1..2
    "success"
  when 3
    "warning"
  when 4
    "danger"
  else
    "dark" # black
  end
end

def get_air_quality_description(aqi)
  case aqi
  when 1
    "Good"
  when 2
    "Fair"
  when 3
    "Moderate"
  when 4
    "Poor"
  when 5
    "Very poor"
  else
    "Not available"
  end
end
