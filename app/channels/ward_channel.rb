class WardChannel < ApplicationCable::Channel
  def subscribed
    ward = Ward.find(params[:id])
    stream_for ward
  end
end
