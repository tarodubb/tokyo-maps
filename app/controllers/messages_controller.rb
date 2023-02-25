class MessagesController < ApplicationController
  def create
    @ward = Ward.find(params[:ward_id])
    @message = Message.new(message_params)
    @message.ward = @ward
    @message.user = current_user
    if @message.save
      WardChannel.broadcast_to(
        @ward,
        render_to_string(partial: "message", locals: { message: @message })
      )
      head :ok
    else
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
