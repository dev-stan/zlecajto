// app/javascript/controllers/conversation_controller.js
import { Controller } from "@hotwired/stimulus"
import { createConversationChannel } from "../channels/conversation_channel"

export default class extends Controller {
  static targets = ["messages", "form", "input", "images"]

  connect() {
    this.conversationId = this.element.dataset.conversationId

    this.channel = createConversationChannel(
      this.conversationId,
      this.receiveMessage.bind(this)
    )

    // Scroll on initial load
    requestAnimationFrame(() => this.scrollToBottom())
  }

  disconnect() {
    if (this.channel) this.channel.unsubscribe()
  }

  // Called by ActionCable when a message is broadcast
  receiveMessage(data) {
    if (data.html) {
      this.messagesTarget.insertAdjacentHTML("beforeend", data.html)
    } else {
      const el = document.createElement("div")
      el.innerHTML = `
        <strong>${data.user_name}</strong>:
        ${data.content}
        <small>${data.created_at}</small>
      `
      this.messagesTarget.appendChild(el)
    }

    this.scrollToBottom(true)
  }

  send(event) {
    event.preventDefault()

    const content = this.inputTarget.value.trim()
    let attachments = []

    if (this.hasImagesTarget && this.imagesTarget.value) {
      try {
        attachments = JSON.parse(this.imagesTarget.value)
      } catch {
        attachments = []
      }
    }

    // Do not send empty messages
    if (content === "" && attachments.length === 0) return

    // Send via ActionCable
    this.channel.perform("receive", {
      content,
      attachments
    })

    // Reset UI
    this.inputTarget.value = ""
    if (this.hasImagesTarget) this.imagesTarget.value = ""

    // Tell the image controller to clear previews
    this.formTarget.dispatchEvent(new CustomEvent("conversation:sent"))

    this.scrollToBottom(true)
  }

  scrollToBottom(smooth = false) {
    if (smooth) {
      this.messagesTarget.scrollTo({
        top: this.messagesTarget.scrollHeight,
        behavior: "smooth"
      })
    } else {
      this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
    }
  }
}
