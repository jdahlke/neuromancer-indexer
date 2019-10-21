# frozen_string_literal: true

require 'neuromancer/indexer/version'
require 'neuromancer/indexer/client'
require 'neuromancer/indexer/configuration'

module Neuromancer
  module Indexer
    class Error < StandardError; end
    class ConfigurationError < Error; end

    def self.config
      @config ||= Configuration.new
    end

    def self.configure
      yield config
      config.validate!

      config
    end

    def self.index(obj)
      @client ||= Client.new
      @client.index(obj)
    end
  end
end
