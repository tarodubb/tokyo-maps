class WardsController < ApplicationController
  def index
    @wards = Ward.all
  end

  def show
    @ward = Ward.find(params[:id])
    @reviews = Review.where(ward: @ward)
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
  end
end
