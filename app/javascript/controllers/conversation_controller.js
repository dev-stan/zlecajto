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

    // Scroll to bottom on initial load after a brief delay to ensure content is rendered
    requestAnimationFrame(() => {
      this.scrollToBottom()
    })
  }

  disconnect() {
    if (this.channel) this.channel.unsubscribe()
  }

  receiveMessage(data) {
    if (data.html) {
      this.messagesTarget.insertAdjacentHTML("beforeend", data.html)
    } else {
      const message = document.createElement("div")
      message.innerHTML = `<strong>${data.user_name}</strong>: ${data.content} <small>${data.created_at}</small>`
      this.messagesTarget.appendChild(message)
    }

    this.scrollToBottom(true)
  }

  send(event) {
    event.preventDefault()
    const content = this.inputTarget.value.trim()
    let images = []
    if (this.hasImagesTarget && this.imagesTarget.value) {
      try {
        images = JSON.parse(this.imagesTarget.value) || []
      } catch (_) {
        images = []
      }
    }

    if (content === "" && images.length === 0) return

    this.channel.perform("receive", { content, images })
    this.inputTarget.value = ""
    if (this.hasImagesTarget) this.imagesTarget.value = ""
    // Notify sibling controller to clear previews
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