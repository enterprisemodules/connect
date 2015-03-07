require 'connect/entries/base'

module Connect
  module Entry
    ##
    #
    # A class representing a connection entry in the values table.
    # An instance of the class connect one entry to an other
    #
    class Connection < Base
      def initialize(name, value, selector = nil, value_table = nil)
        super(name, value, selector)
        @value_table = value_table
      end

      ##
      #
      # Make sure we have the final object in t
      # @return [Any]
      #
      def to_final
        value = @value_table.internal_lookup(@value)
        Connect::Selector.run(value, selector)
      end

      ##
      #
      # Translate the object for external representation
      #
      # @return [Hash] a hash containing the name as key and the data as a [Hash]
      #
      def to_ext
        to_final.to_ext
      end
    end
  end
end
