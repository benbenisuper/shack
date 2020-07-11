class ChatBoxController < ApplicationController
  def show
    @chat_box = ChatBox.includes(messages: :user).find(params[:id])
    authorize @chat_box
    session[:previous_request_url] = session[:current_request_url]
  end

  def create
  end

  private

  def chat_box_params
    params.require(:chat_box).permit(:name)
  end
end
