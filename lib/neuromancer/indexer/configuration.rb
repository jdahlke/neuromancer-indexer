# frozen_string_literal: true

require 'uri'

module Neuromancer
  module Indexer
    class Configuration
      attr_accessor :region
      attr_accessor :sqs_url
      attr_accessor :access_key_id, :secret_access_key

      def initialize
        @region = 'eu-central-1'
      end

      def validate!
        raise ConfigurationError, '\'region\' cannot be empty' if region.to_s.empty?

        raise ConfigurationError, '\'sqs_url\' cannot be empty' if sqs_url.to_s.empty?

        invalid_protocol = '\'sqs_url\' must be a HTTPS url'
        begin
          raise ConfigurationError, invalid_protocol if URI(sqs_url).scheme != 'https'
        rescue StandardError
          raise ConfigurationError, invalid_protocol
        end
      end
    end
  end
end
