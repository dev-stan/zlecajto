// app/javascript/channels/conversation_channel.js
import consumer from "./consumer"

export function createConversationChannel(conversationId, onReceived) {
  const subscription = consumer.subscriptions.create(
    { channel: "ConversationChannel", conversation_id: conversationId },
    {
      connected() {
        // connected
      },
      disconnected() {
        // disconnected
      },
      received(data) {
        if (onReceived) onReceived(data)
      }
    }
  )

  return subscription
}
