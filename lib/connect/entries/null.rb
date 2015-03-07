require 'connect/entries/base'

module Connect
  module Entry
    ##
    #
    # Represents an empty entry in the values table
    #
    class Null < Base
      def initialize
        @value = nil
      end

      ##
      #
      # transform an object so selection can be done. In this case the value will be
      # translated to a [Hash]
      #
      # @return [Hash] the hash of value
      #
      def for_selection
        nil
      end

      ##
      #
      # Translate the object for external representation
      #
      # @return [Hash] a hash containing the name as key and the data as a [Hash]
      #
      def to_ext
        nil
      end
    end
  end
end
