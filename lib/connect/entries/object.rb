require 'connect/entries/base'

module Connect
  module Entry
    ##
    #
    # Represents an object_entry in the values table
    #
    class Object < Base
      ##
      #
      # transform an object so selection can be done. In this case the value will be
      # translated to a [Hash]
      #
      # @return [Hash] the hash of value
      #
      def for_selection
        @value.to_hash
      end

      ##
      #
      # Translate the object for external representation
      #
      # @return [Hash] a hash containing the name as key and the data as a [Hash]
      #
      def to_ext
        { @value.__name__ => @value.to_hash }
      end
    end
  end
end
