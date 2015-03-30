require 'connect/entries/base'

module Connect
  module Entry
    ##
    #
    # A class representing a object entry in the values table.
    #
    class ObjectReference < Base
      attr_accessor :selector

      def initialize(type, name, selector = nil, xref = nil)
        @type     = type
        @name     = name
        @selector = selector
        @xref     = xref
      end

      ##
      #
      # Translate the object for external representation
      #
      # @return [Hash] a hash containing the name as key and the data as a [Hash]
      #
      def to_ext
        value = Connect::Entry::Base.objects_table.lookup(@type, @name).full_representation
        Connect::Selector.run(value, @selector)
      end
    end
  end
end
