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
      class << self
        attr_accessor :objects_table, :values_table
      end

      attr_accessor :selector

      def initialize(value, selector = nil)
        @value    = value
        @selector = selector
      end

      ##
      #
      # Translate the object for external representation
      #
      # @return [Hash] a hash containing the name as key and the data as a [Hash]
      #
      def to_ext
        fail ArgumentError, 'Internal error. to_ext must be implemented'
      end

      ##
      #
      # Translate the object for external representation
      #
      # @return [Hash] a hash containing the name as key and the data as a [Hash]
      #
      def final
        result = self
        while(result.respond_to?(:to_ext)) do
          result = result.to_ext
        end
        result
      end

    end
  end
end
