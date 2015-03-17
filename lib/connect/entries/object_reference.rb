require 'connect/entries/base'

module Connect
  module Entry
    ##
    #
    # A class representing a object entry in the values table.
    #
    class ObjectReference < Base
      def initialize(type, name, selector = nil)
        @type     = type
        @name     = name
        @selector = selector
      end

      ##
      #
      # Translate the object for external representation
      #
      # @return [Hash] a hash containing the name as key and the data as a [Hash]
      #
      def to_ext
        value = Connect::Entry::Base.objects_table.lookup(@type, @name)
        if @selector
          Connect::Selector.run(value.to_hash, @selector)
        else
          value.full_representation
        end
      end
    end
  end
end
