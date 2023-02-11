class WardsController < ApplicationController
  skip_before_action :authenticate_user

  def index
    @wards = Ward.all
  end

  def show
    @ward = Ward.find(param[:id])
  end
end
