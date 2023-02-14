class WardsController < ApplicationController
  def index
    @wards = Ward.all
  end

  def show
    @ward = Ward.find(params[:id])
  end
end
