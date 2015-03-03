require 'dsl/dsl'

class Hiera
  module Backend
    class Dsl_backend
      attr_reader :parsed

      def initialize
        Hiera.debug("DSL Backend initialized")
        configs_dir = Config[:dsl].fetch(:datadir) { '/etc/puppet/config'}
        @dsl    = Dsl.instance(configs_dir)
        @parsed = false
      end

      def lookup(key, scope, order_override, resolution_type)
        parse_config(scope, order_override) unless parsed
        @dsl.lookup_value(key)
      end

      private

      def parse_config(scope, order_override)
        reversed_hierarchy(scope, order_override).each do |source|
          file = Backend.datafile(:dsl, scope, source, "config")
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
        @dsl.include_file(file)
      end
    end
  end
end