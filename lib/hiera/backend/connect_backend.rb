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
    class Connect_backend
      extend Forwardable

      def_delegator :@connect,  :value_definitions,         :value_definitions
      def_delegator :@connect,  :value_references,          :value_references
      def_delegator :@connect,  :object_definitions,        :object_definitions
      def_delegator :@connect,  :object_references,         :object_references

      attr_reader :parsed

      def initialize
        raise 'Connect section not filled in hiera.yaml' if Config[:connect].nil?

        Hiera.debug('CONNECT: Backend initialized')
        @configs_dir = Config[:connect].fetch(:datadir) { '/etc/puppet/config' }
        Hiera.debug("CONNECT: datadir is set to #{@configs_dir}")
        Connect.logger = Hiera.logger
        @connect       = Connect::Dsl.instance(@configs_dir)
        @files         = {}
      end

      ##
      #
      # Lookup an key in the connect configuration
      #
      # @param key [String] key the key to be looked up. Can be a key containing a scope in the form of a::b::c
      # @param scope [Scope] the Puppet scope.
      # @param order_override [Bool] ?
      # @param _resolution_type [?]
      # @return [Any] the value of the specified key.
      #
      def lookup(key, scope, order_override, _resolution_type, _context = nil)
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
      # @return [Any] the value of the specified key.
      #
      def lookup_values(keys, scope, order_override, _resolution_type)
        setup_context(scope, order_override)
        @connect.lookup_values(keys)
      end

      ##
      #
      # Lookup specified objects in the connect configuration
      #
      # @param name [Regexp] the object(s) to be looked up.
      # @param type [String] the object type to be looked up.
      # @param scope [Scope] the Puppet scope.
      # @param order_override [Bool] ?
      # @param _resolution_type [?]
      # @return [Any] the value of the specified key.
      #
      def lookup_objects(keys, type, scope, order_override, _resolution_type)
        setup_context(scope, order_override)
        @connect.lookup_objects(keys, type)
      end

      private

      def setup_context(scope, order_override)
        Connect::Dsl.config.scope = scope # Pass the scope to connect
        return nil unless any_file_changed?(scope, order_override) || lookup_changed?(scope, order_override)

        @connect = Connect::Dsl.instance(@configs_dir)
        parse_config(scope, order_override)
      end

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

      def lookup_changed?(scope, order_override)
        current_lookup = reversed_hierarchy(scope, order_override).collect { |e| e }
        if @last_lookup && @last_lookup == current_lookup
          false
        else
          @last_lookup = current_lookup
          true
        end
      end

      def any_file_changed?(scope, order_override)
        reversed_hierarchy(scope, order_override).each do |file_name|
          return true if file_changed?(file_name, scope)
        end
        false
      end

      def file_changed?(source, scope)
        file_name = Backend.datafile(:connect, scope, source, 'config')
        if file_name && File.exist?(file_name)
          size = File.size(file_name)
          date = File.mtime(file_name)
        else
          size = -1
          date = ''
        end
        file_info = @files.fetch('file_name') { { :size => -1, :date => '' } }
        if (file_info[:size] == size) && (file_info[:date] == date)
          false
        else
          @files[file_name]        = {}
          @files[file_name][:size] = size
          @files[file_name][:date] = date
          true
        end
      end

      def parse_file(file)
        @connect.include_file(file)
      end
    end
  end
end
