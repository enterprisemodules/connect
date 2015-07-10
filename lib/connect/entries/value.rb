require 'connect/entries/base'
require 'connect/conversions'
require 'hash_extensions'

module Connect
  module Entry
    ##
    #
    # Represent an actual value in the values_table
    #
    class Value < Base
      include Connect::Conversions

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
          # Because we've defined some convenience methods for Array's, we
          # force the return value to be of type ExtendedArray
          #
          convert_array(@value)
        when Hash
          #
          # Because we've defined some convenience methods for Hashes, we force
          # the type to be a MathodHash
          #
          convert_hash(@value)
        else
          @value.respond_to?(:final) ? @value.final : @value
        end
        Selector.run(value, selector)
      end
      # rubocop:enable CaseEquality, ElseAlignment, EndAlignment, IndentationWidth
    end
  end
end
