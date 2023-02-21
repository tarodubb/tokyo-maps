class ReviewsController < ApplicationController
  def new
    @ward = Ward.find(params[:ward_id])
    @review = Review.new
  end

  def create
    @ward = Ward.find(params[:ward_id])
    @review = Review.new(review_params)
    @review.ward = @ward
    if @review.save
      redirect_to ward_path(@ward)
    else
      render "wards/show", status: :unprocessable_entity
    end
  end

  private

  def review_params
    params.require(:review).permit(:content, :rating)
  end
end
