require 'connect/entries/object_reference'

module Connect
  module Entry
    ##
    #
    # A class representing a object entry in the values table.
    #
    class RegexpObjectReference < ObjectReference
      def inspect
        "regexp reference to #{@type}(#{@name})#{@selector}"
      end

      ##
      #
      # Translate the object for external representation
      #
      # @return [Hash] a hash containing the name as key and the data as a [Hash]
      #
      def to_ext
        values = Connect::Entry::Base.objects_table.lookup_regexp(@type, @name)
        return values if @selector.nil?

        return_value = {}
        values.each do |key, hash|
          return_value.merge!(key => Connect::Selector.run(hash, @selector))
        end
        return_value
      end
    end
  end
end
