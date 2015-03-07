module Connect
  module Datasources
    #
    # This a a base level class for all datasources. A Datasources allows you to
    # import data from an other source into connect. A datasource **must** implement the `lookup(name)`
    # method. This method **must** return a value. A value can be any of:
    # - Integer
    # - Float
    # - String
    # - Array
    # - Hash
    # - Bolean
    #
    #
    class Base
      ##
      #
      # The initializer is called by the parser. When the parser encounters a
      # ```
      # import from datasource(param1, param2) do....
      # ```
      # The a datasource is instantiated. The params are passed as params to the ` initialize`  function.
      #
      # @param _name [String] The name of the datasource.
      # @param _arguments [Array] The arguments passed by the parser.
      # @return [Datasource::Base] An initalized datasource, ready for doing a lookup
      #
      def initialize(_name, _arguments)
      end

      ##
      #
      # The lookup method is called for every variable in a import block
      # ```
      # import from datasource(param1, param2) do....
      #  value1 = 'lookup_1'
      #  value2 = 'lookp_2'
      # ```
      # will call lookup twice.
      #
      # @param _key [String] The key to lookup in the current datasource
      # @return  The value of the key in the external datasource
      #
      def lookup(_key)
        fail ArgumentError, 'lookup method needs to be overridden in datasource'
      end
    end
  end
end
