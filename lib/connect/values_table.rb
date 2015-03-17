require 'connect/selector'
require 'connect/entries/null'
require 'connect/entries/value'
require 'connect/entries/object_reference'
require 'connect/entries/reference'
require 'method_hash'

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

    def entries
      @values_table.keys
    end

    ##
    #
    # Add an entry to the values tables
    #
    # @param entry [Connect::Entries::Base] an entry to add to the tabke
    #
    def add(entry)
      @values_table.merge!(entry)
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
      entry = @values_table.fetch(name) { Entry::Null.new }
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
    def self.value_entry(name, value, selector = nil)
      { name => Entry::Value.new(value, selector)}
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
    def self.reference_entry(name, reference, selector = nil)
      { name => Entry::Reference.new(reference, selector)}
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
    def self.object_reference_entry(name, object_type, object_name, selector = nil)
      { name => Entry::ObjectReference.new(object_type, object_name, selector)}
    end


  end
end
