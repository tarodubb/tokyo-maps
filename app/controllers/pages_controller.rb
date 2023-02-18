class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @wards = Ward.all.reject { |ward| ward.geojson.nil? }
    @areas = @wards.map do |ward|
      if Rails.env.development?
        path = 'http://localhost:3000/wards'
      else
        path = 'https://tokyo-maps.herokuapp.com/'
      end
      {
        geojson: JSON.parse(ward.geojson),
        name: ward.name,
        id: ward.id,
        path:,
        code: ward.ward_code
      }
    end
    p Rails.env.development?
    p "HERE I AM"
  end
end
