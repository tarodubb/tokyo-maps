class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @wards = Ward.all
    @areas = @wards.each do |ward|
      if Rails.env.development?
        path = 'http://localhost:3000/wards'
      else
        path = 'https://tokyo-maps.herokuapp.com'
      end
      {
        name: ward.name,
        id: ward.id,
        path:,
        code: ward.ward_code
      }
    end
  end
end
