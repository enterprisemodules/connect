require 'connect/entries/base'

module Connect
  module Entry
    class Connection < Base

      def initialize( name, value, selector = nil, value_table = nil)
        super(name, value, selector)
        @value_table = value_table
      end

      def to_final
        value = @value_table.internal_lookup(@value)
        Connect::Selector.run(value, selector)
      end

      def to_ext
        to_final.to_ext
      end

    end
  end
end