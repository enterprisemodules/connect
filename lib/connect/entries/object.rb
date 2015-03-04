require 'connect/entries/base'

module Connect
  module Entry

    class Object < Base

      def for_selection
        @value.to_hash
      end

      def to_ext
        { @value.__name__ => @value.to_hash}
      end

    end
  end
end