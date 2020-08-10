# frozen_string_literal: true

module Neuromancer
  module Indexer
    class Document
      attr_reader :id, :type, :body

      def initialize(attributes)
        @id = indifferent_value(attributes, :id).to_s
        @type = indifferent_value(attributes, :type).to_s
        @body = indifferent_value(attributes, :body)
      end

      def as_json
        {
          id: id,
          type: type,
          body: body
        }
      end

      def validate!
        errors = []

        errors << 'document#id is empty' if id.empty?
        errors << 'document#type is empty' if type.empty?
        errors << 'document#body is not a Hash' unless body.is_a?(Hash)

        raise(InvalidDocument, errors) unless errors.empty?
      end

      def indifferent_value(hash, key)
        hash[key.to_sym] || hash[key.to_s]
      end
    end
  end
end
