require 'connect/entries/base'

module Connect
  module Entry
    class Null < Base

      def initialize()
        @value = nil
      end

      def for_selection
        nil
      end

      def to_ext
        nil
      end

    end
  end
end