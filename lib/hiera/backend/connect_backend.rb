require 'connect/dsl'

class Hiera
  #
  # Hier backend are the objects that implement the hiera lookups
  #
  module Backend
    ##
    #
    # The hiera backend uses the Connect language to express your data. You can use
    # regular hiera functionality to lookup the data
    #
    # rubocop:disable ClassAndModuleCamelCase
    class Connect_backend
      attr_reader :parsed

      def initialize
        Hiera.debug('DSL Backend initialized')
        configs_dir = Config[:connect].fetch(:datadir) { '/etc/puppet/config' }
        @connect    = Connect::Dsl.instance(configs_dir)
        @parsed = false
      end

      ##
      #
      # Lookup an key in the connect configuration
      #
      # @param key [String] key the key to be looked up. Can be a ke containing a scope in the form of a::b::c
      # @param scope [Scope] the Puppet scope.
      # @param order_override [Bool] ?
      # @param _resolution_type [?]
      # @return [Any] the value of the specfied key.
      #
      def lookup(key, scope, order_override, _resolution_type)
        Connect::Dsl.config.scope = scope  # Pass the scope to connect
        parse_config(scope, order_override) unless parsed
        @connect.lookup_value(key)
      end

      private

      def parse_config(scope, order_override)
        reversed_hierarchy(scope, order_override).each do |source|
          file = Backend.datafile(:connect, scope, source, 'config')
          parse_file(file) if file
        end
      end

      def reversed_hierarchy(scope, order_override)
        hierarchy = []
        Backend.datasources(scope, order_override) do |source|
          hierarchy.unshift(source)
        end
        hierarchy
      end

      def parse_file(file)
        Hiera.debug "parsing config file #{file}."
        @connect.include_file(file)
      end
    end
    # rubocop:enable ClassAndModuleCamelCase
  end
end
