class MessagesController < ApplicationController
  def create
    @message = Message.new(message_params)
    authorize @message
    @chat_box = ChatBox.find(params[:chat_box_id])
    @message.chat_box = @chat_box
    @message.user = current_user
    if @message.save
      respond_to do |format|
        format.html { redirect_to booking_path(@chat_box.booking) }
        format.js
      end
    else
      respond_to do |format|
        format.html { render "chat_box/show" }
        format.js
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
