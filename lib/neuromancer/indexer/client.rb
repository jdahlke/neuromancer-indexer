# frozen_string_literal: true

require 'json'
require 'aws-sdk-sqs'

module Neuromancer
  module Indexer
    class Client
      attr_reader :config, :sqs

      def initialize(sqs)
        @config = Neuromancer::Indexer.config
        @sqs = sqs || Aws::SQS::Client.new(region: config.region)
      end

      def index(obj)
        message = obj.to_json
        validate_message!(message)

        sqs.send_message({
          queue_url: config.sqs_url,
          message_body: message,
          delay_seconds: 1
        })
      end

      private

      def validate_message!(message)
        hash = JSON.parse(message)
        id = hash['id'].to_s
        type = hash['type'].to_s
        body = hash['body']

        if id.empty?
          raise Error, 'Key `id` in obj cannot be empty'
        end

        if type.empty?
          raise Error, 'Key `type` in obj cannot be empty'
        end

        if !body.is_a?(Hash)
          raise Error, 'Key `body` must be a Hash'
        end
      end
    end
  end
end
