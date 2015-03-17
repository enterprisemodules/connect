require 'connect/entries/base'

module Connect
  module Entry
    ##
    #
    # A class representing a reference entry in the values table.
    # An instance of the class connect one entry to an other
    #
    class Reference < Base
      ##
      #
      # Translate the object for external representation
      #
      # @return [Hash] a hash containing the name as key and the data as a [Hash]
      #
      def to_ext
        value = Connect::Entry::Base.values_table.internal_lookup(@value)
        # TODO: What if we have multiple references
        Connect::Selector.run(value, @selector)
      end
    end
  end
end
