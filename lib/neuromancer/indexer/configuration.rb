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
        if region.to_s.empty?
          raise ConfigurationError, '`region` cannot be empty'
        end

        if sqs_url.to_s.empty?
          raise ConfigurationError, '`sqs_url` cannot be empty'
        end

        begin
          if URI(sqs_url).scheme != 'https'
            raise ConfigurationError, '`sqs_url` must be a HTTPS url'
          end
        rescue => e
          raise ConfigurationError, '`sqs_url` must be a HTTPS url'
        end
      end
    end
  end
end

