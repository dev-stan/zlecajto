import consumer from "channels/consumer"

export function createConversationChannel(conversationId, onReceived) {
  return consumer.subscriptions.create(
    { channel: "ConversationChannel", conversation_id: conversationId },
    {
      received(data) {
        if (onReceived) onReceived(data)
      }
    }
  )
}
