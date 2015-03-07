require 'connect/entries/base'

module Connect
  module Entry
    ##
    #
    # Represent an actual value in the values_table
    #
    class Value < Base
      ##
      #
      # Translate the object for external representation
      #
      # @return [Hash] a hash containing the name as key and the data as a [Hash]
      #
      # rubocop:disable CaseIndentation, EndAlignment, IndentationWidth
      def to_ext
        value = case @value
        when Array
          @value.map { |e| e.respond_to?(:to_ext) ? e.to_ext : e }
        when Hash
          MethodHash[@value.map { |k, v| convert_hash_entry(k, v) }]
        else
          @value
        end
        value
      end
      # rubocop:enable CaseEquality, ElseAlignment, EndAlignment, IndentationWidth

      ##
      #
      # transform an object so selection can be done. In this case the value will be
      # translated to a [Hash]
      #
      # @return [Hash] the hash of value
      #
      # rubocop:disable TrivialAccessors
      def for_selection
        @value
      end
      # rubocop:enable TrivialAccessors

      private

      def convert_hash_entry(k, v)
        if v.is_a?(ObjectDefinition) && v.object_id == k # Special case
          key, value = v.to_ext.to_a[0]
          [key, value]
        else
          v.respond_to?(:to_ext) ? [k, v.to_ext] : [k, v]
        end
      end
    end
  end
end
