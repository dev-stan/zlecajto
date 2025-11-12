// app/javascript/controllers/conversation_controller.js
import { Controller } from "@hotwired/stimulus"
import { createConversationChannel } from "../channels/conversation_channel"

export default class extends Controller {
  static targets = ["messages", "form", "input"]

  connect() {
    this.conversationId = this.element.dataset.conversationId
    this.channel = createConversationChannel(this.conversationId, this.receiveMessage.bind(this))
  }

  disconnect() {
    this.channel.unsubscribe()
  }

  receiveMessage(data) {
    const message = document.createElement("div")
    message.innerHTML = `<strong>${data.user_name}</strong>: ${data.content} <small>${data.created_at}</small>`
    this.messagesTarget.appendChild(message)
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
  }


  send(event) {
    event.preventDefault()

    const content = this.inputTarget.value.trim()
    if (content === "") return

    this.channel.perform("receive", { content })
    this.inputTarget.value = ""
  }
}
