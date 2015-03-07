require 'connect/object_definition'
require 'puppet'
require 'puppet/pops'

module Connect
  ##
  #
  # Implements a table to keep all object definitions is. The table is index by name
  #
  #
  class ObjectsTable
    def initialize
      @objects_table = {}
    end

    ##
    #
    # Add an object to the objects table.
    #
    # @param type [String] the type of object to lookup
    # @param name [String] the name of the object to lookup
    # @param values [Hash] a [Hash] containing all the values of the object
    def add(type, name, values)
      object = from_table(type, name)
      add_values_to_existing!(object, values)
    end

    ##
    #
    # Lookup an object with a specfied type and name in the object table
    #
    # @param type [String] the type of object to lookup
    # @param name [String] the name of the object to lookup
    # @return [ObjectDefinition] the object definition
    def lookup(type, name)
      from_table(type, name)
    end

    #
    # Autoload a ruby class based on the type of the object. If it doesn't exists, just
    # instantiate a ObjectDefinition. This mechanism allows extension of the connect classes
    # with user written classes.
    #
    # @param type [String] the type name of the object
    # @param name [String] the name of the object
    # #param values [Hash] a [Hash] containing all values
    #
    def self.entry(type, name, values)
      type_name = type.to_s.capitalize
      klass_name = "Connect::Objects::#{type_name}"
      klass = Puppet::Pops::Types::ClassLoader.provide_from_string(klass_name)
      klass ? klass.new(type, name, values) : ObjectDefinition.new(type, name, values)
    end

    private

    def key(type, name)
      "__#{name}__#{type}__"
    end

    def add_new_object(type, name, values)
      object = ObjectsTable.entry(type, name, values)
      to_table(object)
    end

    def from_table(type, name)
      @objects_table.fetch(key(type, name)) { add_new_object(type, name, {}) }
    end

    def to_table(object)
      type = object.__type__
      name = object.__name__
      @objects_table[key(type, name)] = object
    end

    def add_values_to_existing!(object, values)
      object.merge!(values)
    end
  end
end
