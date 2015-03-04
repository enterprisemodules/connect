require 'connect/selector'

module Connect
  module Entry
    class Base

      attr_reader :value, :selector

      def initialize( name, value, selector = nil)
        @name     = name
        @value    = value
        @selector = selector
      end

      def to_entry
        { @name => self}
      end

      def to_final
        Connect::Selector.run(self, selector)
      end

      def to_ext
        nil
      end

      def select
        Connect::Selector.run(self, @selector)
      end

    end
  end
end