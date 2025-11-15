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
    if (data.type === "conversation_closed") {
      this.showConversationClosedBanner()
      this.scrollToBottom(true)
      return
    }
    this.messagesTarget.insertAdjacentHTML("beforeend", data.html)
    this.scrollToBottom(true)
  }

  showConversationClosedBanner() {
    const banner = document.createElement("div")
    banner.className = "flex justify-center px-4 py-3"
    banner.innerHTML = `
      <div class="bg-green-200 rounded-lg p-4 mb-5 flex flex-col items-center gap-2 text-center border border-green-300">
        <img src="/assets/zlecajto_favicon.png" class="h-12 w-auto rounded-lg" />
        <p class="font-medium">Odwołano</p>
      </div>
    `

    this.messagesTarget.appendChild(banner)
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
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
