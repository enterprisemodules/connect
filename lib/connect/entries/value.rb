require 'connect/entries/base'
require 'hash_extensions'

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
          #
          # Because we've defined some convinieance methods for Array's, we 
          # force the return value to be of type ExtendedArray
          #
          Connect::ExtendedArray.new(@value.map { |e| e.respond_to?(:final) ? e.final : e })
        when Hash
          #
          # Because we've defined some conveniance methods for Hashes, we force
          # the type to be a MathodHash
          #
          MethodHash[@value.map { |k, v| convert_hash_entry(k, v) }]
        else
          @value.respond_to?(:final) ? @value.final : @value
        end
        Selector.run(value, selector)
      end
      # rubocop:enable CaseEquality, ElseAlignment, EndAlignment, IndentationWidth

      private

      def convert_hash_entry(k, v)
        if v.is_a?(ObjectReference) && v.object_id == k # Special case
          key, value = v.final.to_a[0]
          [key, value]
        else
          v.respond_to?(:final) ? [k, v.final] : [k, v]
        end
      end

    end
  end
end
