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
      # @param _file_name [String] The absolute file name to open.
      # @return [Datasource::Base] An initialized datasource
      #
      def initialize(_name, _file_name)
        super
        # TODO: implement this
      end
      ##
      #
      # Lookup a key in a parsed yaml file en return it.
      #
      # @param _key [String] the lookup key of the data to lookup in the current yaml
      # @return The value at the key.
      def lookup(_key)
      end
    end
  end
end
