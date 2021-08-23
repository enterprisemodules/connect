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
    # Give all entries in the objects table based on the specified type and name.
    # As name, you can specify a regular expression.
    #
    #
    def entries(type, name = /.*/)
      all_keys = @objects_table.keys.select { |k| Regexp.new(key(type, name)).match(k) }.sort
      all_keys.collect { |key| identity(key) }
    end

    ##
    #
    # return the array of defintions for the specified object
    #
    # @return defintions [Array] the Array of definitions
    #
    def definitions(type, name)
      key = key(type, name)
      entry = @objects_table.fetch(key) { raise "internal error. Object #{type} #{name} not found" }
      entry.xref.filter_map { |e| e.instance_of?(Connect::Xdef) ? [e.file_name, e.lineno] : nil }
    end

    ##
    #
    # return the array of references for the specified parameter
    #
    # @return defintions [Array] the Array of references
    #
    def references(type, name)
      key = key(type, name)
      entry = @objects_table.fetch(key) { raise "internal error. Object #{type} #{name} not found" }
      entry.xref.filter_map { |e| e.instance_of?(Connect::Xref) ? [e.file_name, e.lineno] : nil }
    end

    ##
    #
    # Add an object to the objects table.
    #
    # @param type [String] the type of object to lookup
    # @param name [String] the name of the object to lookup
    # @param values [Hash] a [Hash] containing all the values of the object
    def add(type, name, values, xref = nil)
      object = register_reference(type, name, xref)
      add_values_to_existing!(object, values)
    end

    def register_reference(type, name, xref)
      object = from_table(type, name)
      object.add_reference(xref)
      object
    end

    ##
    #
    # Lookup an object with a specified type and name in the object table
    #
    # @param type [String] the type of object to lookup
    # @param name [String] the name of the object to lookup
    # @return [ObjectDefinition] the object definition
    def lookup(type, name)
      name = name.to_ext if name.is_a?(Connect::Entry::Base)
      from_table(type, name)
    end

    ##
    #
    # Lookup multile objects with a specified type and a regexp name in the object table
    #
    # @param type [String] the type of object to lookup
    # @param name [Regexp] the name of the object to lookup
    # @return [Hash] the object definition
    def lookup_regexp(type, regexp)
      return_value = {}
      entries(type, regexp).each do |t, name|
        return_value.merge!(from_table(t, name).full_representation)
      end
      return_value
    end

    ##
    #
    # return the content of the objects table in human readable format
    #
    # @return table [String] the contents of the tabke
    #
    def dump
      output = ''
      @objects_table.keys.sort.each do |key|
        object_entry = @objects_table[key]
        name = object_entry.__name__
        type = object_entry.__type__
        #
        # use the inspect to make ruby 1.8.7 and 1.9.3 compatible
        #
        object = lookup(type, name).to_hash.inspect
        output << "#{type}(#{name}) = #{object}\n"
      end
      output
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
      # Use send, because in later versions of puppet it has become a private method
      klass = Puppet::Pops::Types::ClassLoader.send(:provide_from_string, klass_name)
      klass ? klass.new(type, name, values) : ObjectDefinition.new(type, name, values)
    end

    private

    def key(type, name)
      "__#{name}__#{type}__"
    end

    def identity(key)
      match = key.match(/__(.*)__(.*)__/).to_a
      match.shift
      match.reverse
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
