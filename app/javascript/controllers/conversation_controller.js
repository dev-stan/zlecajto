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

    requestAnimationFrame(() => this.scrollToBottom())
  }

  disconnect() {
    if (this.channel) this.channel.unsubscribe()
  }

  // Called by ActionCable when a message is broadcast
  receiveMessage(data) {
    this.messagesTarget.insertAdjacentHTML("beforeend", data.html)
    setTimeout(() => this.scrollToBottom(true), 500)
    console.log("hello world")
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
    if (!this.hasMessagesTarget) return

    const el = this.messagesTarget

    const doScroll = () => {
      if (smooth) {
        el.scrollTo({
          top: el.scrollHeight,
          behavior: "smooth"
        })
      } else {
        el.scrollTop = el.scrollHeight
      }
    }

    // Defer to the next frame so DOM/layout reflects new content
    requestAnimationFrame(doScroll)
  }
}
