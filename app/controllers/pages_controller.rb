class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @ward = Ward.new
    @wards = Ward.all
    @areas = @wards.each do |ward|
      {
        name: ward.name,
        id: ward.id,
        code: ward.ward_code,
        one_ldk: ward.one_ldk_avg_rent,
        two_ldk: ward.two_ldk_avg_rent,
        three_ldk: ward.three_ldk_avg_rent
      }
    end
    if current_user && current_user.address
      @user_address = {
        coord: [current_user.longitude, current_user.latitude],
        marker_html: render_to_string(partial: "marker")
      }
    end
  end
end
