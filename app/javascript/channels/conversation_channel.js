import consumer from "./consumer"

// Debug helper: logs all incoming payloads so we can verify broadcasts arrive.
// Remove console.log once things are stable.
export function createConversationChannel(conversationId, onReceived) {
  return consumer.subscriptions.create(
    { channel: "ConversationChannel", conversation_id: conversationId },
    {
      received(data) {
        // eslint-disable-next-line no-console
        console.log("[ConversationChannel] received:", data)
        if (onReceived) onReceived(data)
      }
    }
  )
}
