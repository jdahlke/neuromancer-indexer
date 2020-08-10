# frozen_string_literal: true

require 'json'
require 'aws-sdk-sqs'

require 'neuromancer/indexer/version'
require 'neuromancer/indexer/client'
require 'neuromancer/indexer/document'
require 'neuromancer/indexer/configuration'

module Neuromancer
  module Indexer
    class Error < StandardError
    end

    class ConfigurationError < Error
    end

    class InvalidDocument < Error
      attr_reader :errors

      def initialize(errors)
        @errors = errors
      end

      def message
        errors.join(', ')
      end

      def inspect
        "#<#{self.class.name}: '#{message}'>"
      end
    end

    def self.config
      @config ||= Configuration.new
    end

    def self.configure
      yield config
      config.validate!

      config
    end

    def self.client
      @client ||= Client.new
    end

    def self.index(obj)
      client.index(obj)
    end

    def self.delete(obj)
      client.delete(obj)
    end
  end
end
