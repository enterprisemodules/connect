require 'connect/selector'
require 'connect/entries/null'
require 'connect/entries/value'
require 'connect/entries/connection'
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
    # Finds an entry in the lookup table and translates it to the external representationof it.
    #
    # @param name [String] the key/name of the entry in the list
    # @return the value
    #
    def lookup(name)
      value = internal_lookup(name)
      value = value.is_a?(Entry::Base) ? value.select : value
      value.respond_to?(:to_ext) ? value.to_ext : value
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
      entry.to_final
    end

    ##
    #
    # Create a value entry for the value table.
    #
    # @param name [String] the name/ket of the entry
    # @param value [Any] the value to be stored
    # @param selector [String] the selector to be applied
    # @return [Connect::Entries::Base] an entry for the table
    #
    def self.value_entry(name, value, selector = nil)
      Entry::Value.new(name, value, selector).to_entry
    end

    ##
    #
    # Create a connection entry for the value table.
    #
    # @param name [String] the name/ket of the entry
    # @param value [Any] the value to be stored
    # @param selector [String] the selector to be applied
    # @return [Connect::Entries::Base] an entry for the table
    #
    def self.connection_entry(name, value, selector = nil, value_table = nil)
      fail ArgumentError, 'invalid value_table' if value_table.nil?
      Entry::Connection.new(name, value, selector, value_table).to_entry
    end
  end
end
