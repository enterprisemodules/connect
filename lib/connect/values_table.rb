require 'connect/selector'
require 'connect/entries/value'
require 'connect/entries/object_reference'
require 'connect/entries/regexp_object_reference'
require 'connect/entries/reference'
require 'method_hash'
require 'hiera'

module Connect
  ##
  #
  # A list of values that are indexed by a key name. The list can contain different kind of
  # elements
  #
  class ValuesTable
    def initialize
      @values_table = {}
    end

    ##
    #
    # Give all entries in the values table based on the specified name.
    # As name, you can specify a regular expression.
    #
    # @return [Array]
    #
    def entries(name = /.*/)
      @values_table.keys.select { |k| Regexp.new(name).match(k) }.sort
    end

    ##
    #
    # return the array of defintions for the specified parameter
    #
    # @return defintions [Array] the Array of definitions
    #
    def definitions(parameter)
      entry = @values_table.fetch(parameter) { raise "internal error. Parameter entry #{parameter} not found" }
      entry.xref.collect { |e| e.instance_of?(Connect::Xdef) ? [e.file_name, e.lineno] : nil }.compact
    end

    ##
    #
    # return the array of references for the specified parameter
    #
    # @return defintions [Array] the Array of references
    #
    def references(parameter)
      entry = @values_table.fetch(parameter) { raise "internal error. Parameter entry #{parameter} not found" }
      entry.xref.collect { |e| e.instance_of?(Connect::Xref) ? [e.file_name, e.lineno] : nil }.compact
    end

    ##
    #
    # Register a cross reference in the entry for the specified parameter
    #
    def register_reference(parameter, xref)
      entry = @values_table.fetch(parameter) do
        value = Entry::Value.new(nil)
        add(parameter => value)
        value
      end
      entry.add_reference(xref)
    end

    ##
    #
    # Add an entry to the values tables
    #
    # @param entry [Connect::Entries::Base] an entry to add to the tabke
    #
    def add(entry)
      if exists?(entry)
        @values_table[entry.keys.first].merge!(entry.values.first)
      else
        @values_table.merge!(entry)
      end
    end

    ##
    #
    # return the content of the values table in human readable format
    #
    # @return table [String] the contents of the tabke
    #
    def dump
      output = ''
      @values_table.keys.sort.each do |key|
        #
        # Use inspect, to make ruby 1.8.7 and ruby 1.8 and higher compatible
        output << "#{key} = #{lookup(key).inspect}\n"
      end
      output
    end

    ##
    #
    # Finds an entry in the lookup table and translates it to the external representationof it.
    #
    # @param name [String] the key/name of the entry in the list
    # @return the value
    #
    def lookup(name)
      internal_lookup(name).final
    end

    ##
    #
    # Lookup an entry in the values table
    #
    # @param name [String] the name/key to lookup in the list
    # @return the internal representation of the value in the table
    #
    def internal_lookup(name)
      name = name.to_s
      # TODO: Check if name is a valid name
      if Gem::Version.new(::Hiera.version) > Gem::Version.new('2.0.0')
        @values_table.fetch(name) do
          Connect.debug("looked up '#{name}' but found nothing")
          throw :no_such_key
        end
      else
        @values_table.fetch(name) { Entry::Value.new(nil) }
      end
    end

    ##
    #
    # Create a value entry for the value table.
    #
    # @param name [String] the name/ket of the entry
    # @param value [Any] the value to be stored
    # @param selector [String] the selector to be applied
    # @return [Hash] a Hash containing the name and the entry for the table
    #
    def self.value_entry(name, value, selector = nil, xref = nil)
      { name => Entry::Value.new(value, selector, xref) }
    end

    ##
    #
    # Create a reference entry for the value table.
    #
    # @param name [String] the name of the entry
    # @param reference [Any] the value to be referenced
    # @param selector [String] the selector to be applied
    # @return [Hash] a Hash containing the name and the entry for the table
    #
    def self.reference_entry(name, reference, selector = nil, xref = nil)
      { name => Entry::Reference.new(reference, selector, xref) }
    end

    ##
    #
    # Create a object reference entry for the value table.
    #
    # @param name [String] the name of the entry
    # @param object_type [String] the object type to be referenced
    # @param object_name [String] the object name to be referenced
    # @param selector [String] the selector to be applied
    # @return [Hash] a Hash containing the name and the entry for the table
    #
    def self.object_reference_entry(name, object_type, object_name, selector = nil, xref = nil)
      { name => Entry::ObjectReference.new(object_type, object_name, selector, xref) }
    end

    private

    def exists?(entry)
      @values_table.key?(entry.keys.first)
    end
  end
end
