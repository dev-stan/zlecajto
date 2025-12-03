import { Controller } from "@hotwired/stimulus"
import { createConversationChannel } from "../channels/conversation_channel"

export default class extends Controller {
  static targets = ["messages", "form", "input", "images", "footer"]

  focusInput() {
    this.footerTarget.classList.add("!pb-4")
  }

  blurInput() {
    this.footerTarget.classList.remove("!pb-4")
  }

  setVh() {
    let vh = window.innerHeight * 0.01;
    document.documentElement.style.setProperty('--vh', `${vh}px`);
  }

  connect() {
    this.setVh();
    window.addEventListener('resize', this.setVh.bind(this));
    this.conversationId = this.element.dataset.conversationId

    this.previousBodyOverflow = document.body.style.overflow
    this.previousDocumentOverflow = document.documentElement.style.overflow
    document.body.style.overflow = "hidden"
    document.documentElement.style.overflow = "hidden"

    this.channel = createConversationChannel(
      this.conversationId,
      this.receiveMessage.bind(this)
    )

    requestAnimationFrame(() => this.scrollToBottom())
  }

  disconnect() {
    document.body.style.overflow = this.previousBodyOverflow || ""
    document.documentElement.style.overflow = this.previousDocumentOverflow || ""

    if (this.channel) this.channel.unsubscribe()
  }

  // Called by ActionCable when a message is broadcast
  receiveMessage(data) {
    this.messagesTarget.insertAdjacentHTML("beforeend", data.html)
    setTimeout(() => this.scrollToBottom(true), 50)
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
    console.log("Scrolling to bottom", { smooth })
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

    requestAnimationFrame(doScroll)
  }
}
