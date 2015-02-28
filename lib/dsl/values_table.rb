require 'dsl/selector'
require 'method_hash'

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
    if value.class == ObjectEntry
      object_name = value.__name__
      { object_name => value.to_hash}
    else
      value
    end
  end

  ##
  #
  # Lookup an entry in the values table
  #
  def internal_lookup(name)
    name = name.to_s
    # TODO: Check if name is a valid name
    entry = @values_table.fetch(name) { {}}
    selector = entry[:selector]
    type     = entry[:type]
    value    = entry[:value]
    case type
    when :value
      base_value = Selector.run(value, selector)
      value = case base_value
      when Array 
        base_value.map {|e| e.is_a?(ObjectEntry) ? e.to_value : e}
      when Hash
        MethodHash[base_value.map {|k,v| v.is_a?(ObjectEntry) ? [k, v.to_value] : [k, v]}]
      else
        base_value        
      end
    when :connection
      value = internal_lookup(value)
      Selector.run(value, selector)
    when :object
      Selector.run(value, selector)
    else
      nil
    end
  end

  ##
  #
  # Create an entry for the value table. 
  #
  def self.entry_for(name, value, selector = nil, type = :value )
    name = name.to_s
    entry = { name => { :value => value, :type  => type , :selector => selector}}
    entry
  end
  class << self; alias_method :value_entry, :entry_for end


  ##
  #
  # Create a connection entry for the value table
  #
  def self.connection_entry(name, connection, selector = nil)
    entry_for(name, connection, selector , :connection )
  end

  ##
  #
  # Create a connection entry for the value table
  #
  def self.object_entry(name, connection, selector = nil)
    entry_for(name, connection, selector, :object)
  end


end

