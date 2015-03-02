require 'dsl/selector'
require 'method_hash'
require 'dsl/entries/null_entry'
require 'dsl/entries/value_entry'
require 'dsl/entries/connection_entry'
require 'dsl/entries/object_entry'

class ValuesTable

  def initialize
    @values_table = {}
  end

  ##
  # 
  # Add an entry to the values tables
  #
  def add(entry)
    @values_table.merge!(entry)
  end

  def lookup(name)
    value = internal_lookup(name)
    value = value.is_a?(Entry) ? value.select : value
    value.respond_to?(:to_ext) ? value.to_ext : value
  end

  ##
  #
  # Lookup an entry in the values table
  #
  def internal_lookup(name)
    name = name.to_s
    # TODO: Check if name is a valid name
    entry = @values_table.fetch(name) { NullEntry.new}
    entry.to_final
  end


  ##
  #
  # Create a value entry for the value table. 
  #
  def self.value_entry(name, value, selector = nil )
    ValueEntry.new(name, value, selector).to_entry
  end


  ##
  #
  # Create a connection entry for the value table. 
  #
  def self.connection_entry(name, value, selector = nil, value_table = nil)
    debugger if value_table.nil?
    raise ArgumentError, 'invalid value_table' if value_table.nil?
    ConnectionEntry.new(name, value, selector, value_table).to_entry
  end

  ##
  #
  # Create an object entry for the value table. 
  #
  def self.object_entry(name, value, selector = nil )
    ObjectEntry.new(name, value, selector).to_entry
  end


end

