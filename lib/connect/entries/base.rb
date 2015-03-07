require 'connect/selector'

module Connect
  ##
  #
  # This module space is for entries in the values table
  #
  module Entry
    ##
    #
    # A base class for an entry in the values tables
    #
    class Base
      attr_reader :value, :selector

      def initialize(name, value, selector = nil)
        @name     = name
        @value    = value
        @selector = selector
      end

      ##
      #
      # Translate the current entry to an entry
      #
      # @ return [Connect::Entries::Base]
      #
      def to_entry
        { @name => self }
      end

      ##
      #
      # Make sure we have the final object in t
      # @return [Any]
      #
      def to_final
        Connect::Selector.run(self, selector)
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

      ##
      #
      # Apply the selector to the value
      #
      # @return [Any] the selected values in the entry
      def select
        Connect::Selector.run(self, @selector)
      end
    end
  end
end
