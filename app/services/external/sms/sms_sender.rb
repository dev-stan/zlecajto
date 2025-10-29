# frozen_string_literal: true

require 'vonage'
module External
  module Sms
    class SmsSender
      DEFAULT_FROM = 'ZlecajTo'

      def self.send_later(to:, body:, from: nil)
        SendSmsJob.perform_later(to: to, body: body, from: from)
      end

      def self.send_now(to:, body:, from: nil)
        new(to: to, body: body, from: from).call
      end

      def initialize(to:, body:, from: nil)
        @to = to
        @body = body
        @from = from || DEFAULT_FROM
      end

      def call
        client.sms.send(
          from: @from,
          to: @to,
          text: @body,
          type: 'unicode'
        )
      end

      private

      def client
        @client ||= Vonage::Client.new(
          api_key: Rails.application.credentials.dig(:vonage, :api_key),
          api_secret: Rails.application.credentials.dig(:vonage, :api_secret)
        )
      end
    end
  end
end
