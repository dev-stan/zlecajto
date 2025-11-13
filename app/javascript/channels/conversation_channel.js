import consumer from "./consumer"

export function createConversationChannel(conversationId, onReceived) {
  return consumer.subscriptions.create(
    { channel: "ConversationChannel", conversation_id: conversationId },
    {
      connected() {
        console.log("[Cable] connected conversation:", conversationId)
      },
      rejected() {
        console.warn("[Cable] rejected conversation:", conversationId)
      },
      disconnected() {
        console.log("[Cable] disconnected conversation:", conversationId)
      },
      received(data) {
        if (onReceived) onReceived(data)
      }
    }
  )
}
