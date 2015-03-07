require 'connect/datasources/base'

module Connect
  module Datasources
    ##
    #
    # The `YAML` datasource allows you to import  yaml data into connect and use them as normal connect variables.
    #
    #
    class Yaml < Base
      ##
      #
      # Opens and parses a yaml file and keeps the data. The lookup method reads so the lookup method
      # can easily access it
      #
      # @param _name [String] the name of the datasource. In this case it will always be `yaml`
      # @param file_name [String] The absolute file name to open.
      # @return [Datasource::Base] An initialized datasource
      #
      def initialize(_name, file_name)
        super
        @yaml_data ||= YAML.load_file(file_name)
      end
      ##
      #
      # Lookup a key in a parsed yaml file en return it.
      #
      # @param key [String] the lookup key of the data to lookup in the current yaml
      # @return The value at the key.
      def lookup(key)
        @yaml_data[key]
      end
    end
  end
end
