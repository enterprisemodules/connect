module Connect
  module Datasources
    class Base

      def initialize(name, *arguments)
      end

      def lookup(name)
        raise ArgumentError, 'lookup method needs to be overridden in datasource'
      end
    end
  end
end