require 'hiera'
require 'connect/dsl'

class Hiera
  #
  # Hiera backend are the objects that implement the hiera lookups
  #
  module Backend
    ##
    #
    # The hiera backend uses the Connect language to express your data. You can use
    # regular hiera functionality to lookup the data
    #
    # rubocop:disable ClassAndModuleCamelCase
    class Connect_backend
      extend Forwardable

      def_delegator :@connect,  :value_definitions,         :value_definitions
      def_delegator :@connect,  :value_references,          :value_references
      def_delegator :@connect,  :object_definitions,        :object_definitions
      def_delegator :@connect,  :object_references,         :object_references

      attr_reader :parsed

      def initialize
        fail 'Connect section not filled in hiera.yaml' if Config[:connect].nil?
        Hiera.debug('CONNECT: Backend initialized')
        configs_dir    = Config[:connect].fetch(:datadir) { '/etc/puppet/config' }
        Hiera.debug("CONNECT: datadir is set to #{configs_dir}")
        @connect       = Connect::Dsl.instance(configs_dir)
        Connect.logger = Hiera.logger
        @parsed        = false
      end

      ##
      #
      # Lookup an key in the connect configuration
      #
      # @param key [String] key the key to be looked up. Can be a key containing a scope in the form of a::b::c
      # @param scope [Scope] the Puppet scope.
      # @param order_override [Bool] ?
      # @param _resolution_type [?]
      # @return [Any] the value of the specfied key.
      #
      def lookup(key, scope, order_override, _resolution_type, context = nil)
        setup_context(scope, order_override)
        value = @connect.lookup_value(key)
        Hiera.debug("CONNECT: looked up '#{key}' found '#{value}'")
        value
      end

      ##
      #
      # Lookup specified values in the connect configuration
      #
      # @param keys [Regexp] key the keys to be looked up. Can be a key containing a scope in the form of a::b::c
      # @param scope [Scope] the Puppet scope.
      # @param order_override [Bool] ?
      # @param _resolution_type [?]
      # @return [Any] the value of the specfied key.
      #
      def lookup_values(keys, scope, order_override, _resolution_type)
        setup_context(scope, order_override)
        @connect.lookup_values(keys)
      end


      ##
      #
      # Lookup specfied objects in the connect configuration
      #
      # @param name [Regexp] the object(s) to be looked up.
      # @param type [String] the object type to be looked up. 
      # @param scope [Scope] the Puppet scope.
      # @param order_override [Bool] ?
      # @param _resolution_type [?]
      # @return [Any] the value of the specfied key.
      #
      def lookup_objects(keys, type, scope, order_override, _resolution_type)
        setup_context(scope, order_override)
        @connect.lookup_objects(keys, type)
      end


      private

      def setup_context(scope, order_override)
        Connect::Dsl.config.scope = scope  # Pass the scope to connect
        parse_config(scope, order_override) unless @parsed
      end


      def parse_config(scope, order_override)
        reversed_hierarchy(scope, order_override).each do |source|
          file = Backend.datafile(:connect, scope, source, 'config')
          parse_file(file) if file
        end
        @parsed = true
        @connect.dump_values if @dump_values
        @connect.dump_objects if @dump_objects
      end

      def reversed_hierarchy(scope, order_override)
        hierarchy = []
        Backend.datasources(scope, order_override) do |source|
          hierarchy.unshift(source)
        end
        hierarchy
      end

      def parse_file(file)
        @connect.include_file(file)
      end
    end
    # rubocop:enable ClassAndModuleCamelCase
  end
end
