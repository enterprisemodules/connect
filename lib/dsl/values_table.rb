require 'dsl/selector'

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

  ##
  #
  # Lookup an entry in the values table
  #
  def lookup(name, selector = nil)
    name = name.to_s
    # TODO: Check if name is a valid name
    entry = @values_table.fetch(name) { {}}
    value = case entry[:type]
    when :value
      entry[:value]
    when :connection
      value = lookup(entry[:value], entry[:selector])
    when :object
      object = entry[:value]
      object_name = object.__name__
      selector ? Selector.execute(object, selector) : { object_name => object.to_hash}
    else
      nil
    end
  end

  ##
  #
  # Create an entry for the value table. 
  #
  def self.entry_for(name, value, type = :value, selector = nil)
    name = name.to_s
    entry = { name => { :value => value, :type  => type , :selector => selector}}
    entry
  end
  class << self; alias_method :value_entry, :entry_for end


  ##
  #
  # Create a connection entry for the value table
  #
  def self.connection_entry(name, connection, selector)
    entry_for(name, connection, :connection, selector)
  end

  ##
  #
  # Create a connection entry for the value table
  #
  def self.object_entry(name, connection)
    entry_for(name, connection, :object)
  end


end

