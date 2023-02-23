class ReviewsController < ApplicationController
  def new
    @review = Review.new
  end

  def create
    @ward = Ward.find(params[:ward_id])
    new_params = review_params
    new_params[:user_id] = current_user.id
    @review = Review.new(new_params)
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
