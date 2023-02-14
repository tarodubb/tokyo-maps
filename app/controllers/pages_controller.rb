class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @wards = Ward.all.reject {|ward| ward.geojson.nil?}
    @areas = @wards.map do |ward|
      {
        geojson: JSON.parse(ward.geojson),
        name: ward.name
      }
    end
  end
end
