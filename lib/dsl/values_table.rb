require 'dsl/selector'
require 'method_hash'
require 'dsl/entries/null_entry'
require 'dsl/entries/value_entry'
require 'dsl/entries/connection_entry'
require 'dsl/entries/object_entry'

require 'byebug'

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

    # entry.to_value
    # case type
    # when :value
    #   base_value = Selector.run(value, selector)
    #   value = case base_value
    #   when Array 
    #     base_value.map {|e| e.is_a?(ObjectDefinition) ? e.to_value : e}
    #   when Hash
    #     MethodHash[base_value.map {|k,v| v.is_a?(ObjectDefinition) ? [k, v.to_value] : [k, v]}]
    #   else
    #     base_value        
    #   end
    # when :connection
    #   value = internal_lookup(value)
    #   Selector.run(value, selector)
    # when :object
    #   Selector.run(value, selector)
    # else
    #   nil
    # end
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
  def self.connection_entry(name, value, selector = nil, value_table )
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

