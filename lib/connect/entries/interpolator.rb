require 'connect/entries/base'
require 'connect/interpolator'

module Connect
  module Entry
    ##
    #
    # A class representing a reference entry in the values table.
    # An instance of the class connect one entry to an other
    #
    class Interpolator < Base
      ##
      #
      # Translate the object for external representation
      #
      # @return [Hash] a hash containing the name as key and the data as a [Hash]
      #
      def to_ext
        Connect::Interpolator.new(Connect::Entry::Base.values_table).translate(@value)
      end

      def to_s
        to_ext
      end

      def inspect
        "interpolator containing '#{@value}'"
      end
    end
  end
end
