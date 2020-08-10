# frozen_string_literal: true

module Neuromancer
  module Indexer
    class Client
      attr_reader :config

      def initialize(sqs = nil)
        @config = Neuromancer::Indexer.config
        @sqs = sqs
      end

      def index(id:, type:, body:)
        document = Document.new(id: id, type: type, body: body)
        document.validate!

        enqueue(action: 'index', document: document)
      end

      def delete(id:, type:)
        document = Document.new(id: id, type: type, body: {})
        document.validate!

        enqueue(action: 'delete', document: document)
      end

      def enqueue(action:, document:)
        message = {
          action: action,
          document: document
        }

        sqs.send_message(
          queue_url: config.sqs_url,
          message_body: message.to_json,
          delay_seconds: 1
        )
      end

      private

      def sqs
        @sqs ||= Aws::SQS::Client.new(sqs_options)
      end

      def sqs_options
        options = {
          region: config.region
        }
        if present?(config.access_key_id) && present?(config.secret_access_key)
          options[:credentials] = Aws::Credentials.new(
            config.access_key_id,
            config.secret_access_key
          )
        end

        options
      end

      def present?(value)
        return false if value.nil?
        return false if value.empty?

        true
      end
    end
  end
end
