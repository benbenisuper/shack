import consumer from "./consumer"

const chatBox = document.getElementById("chatbox");

if (chatBox) {
  consumer.subscriptions.create({ channel: "ChatBoxChannel", room: "Best Box", chat_box_id: chatBox.dataset.id }, {
  received(data) {
    if (data["current_user_id"] != chatBox.dataset.userId) {
      this.appendLine(data)
      scrollLastMessageIntoView();
    }
  },

  appendLine(data) {
    console.log(data)
    const element = document.querySelector(".messages")
    element.insertAdjacentHTML("beforeend", data["message_partial"])
  }
})
}

