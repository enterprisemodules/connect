require 'ruby-debug'
require 'dsl/dsl'

class Hiera
  module Backend
    class Dsl_backend
      attr_reader :parsed

      def initialize
        Hiera.debug("DSL Backend initialized")
        @dsl    = Dsl.new # Initialize the DSL
        @parsed = false
      end

      def lookup(key, scope, order_override, resolution_type)
        parse_config(scope, order_override) unless parsed
        @dsl.value_for(key)
      end

      private

      def parse_config(scope, order_override)
        Backend.datasources(scope, order_override) do |source|
          file = Backend.datafile(:dsl, scope, source, "config")
          parse_file(file) if file
        end
      end

      def parse_file(file)
        Hiera.debug "parsing config file #{file}."
        config = File.read(file)
        @dsl.instance_eval(config)
      end
    end
  end
end