class Message < ApplicationRecord
  belongs_to :chat_box
  belongs_to :user
  validates :content, presence: true, allow_blank: false
  after_create :broadcast_message

  def from?(some_user)
    user == some_user
  end

  def broadcast_message
    ActionCable.server.broadcast("chat_box_#{chat_box.id}", {
      message_partial: ApplicationController.renderer.render(partial: "messages/message", locals: { message: self, user_is_messages_author: false }),
      current_user_id: user.id
    })
  end
end
