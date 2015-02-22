
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
  def lookup(name)
    name = name.to_s
    scope, selector = name.split(/(\[\d+\]|\.\D.*)/)
    # TODO: Check if name is a valid name
    entry = @values_table.fetch(scope) { {}}
    value = case entry[:type]
    when :value
      entry[:value]
    when :connection
      lookup(entry[:value])
    when :object
      object = entry[:value]
      object_name = object.__name__
      value = selector ? select(selector, object) : object
      { object_name => object.to_hash}
    else
      nil
    end
  end

  ##
  #
  # Create an entry for the value table. 
  #
  def self.entry_for(name, value, type = :value)
    name = name.to_s
    entry = { name => { :value => value, :type  => type }}
    entry
  end
  class << self; alias_method :value_entry, :entry_for end


  ##
  #
  # Create a connection entry for the value table
  #
  def self.connection_entry(name, connection)
    entry_for(name, connection, :connection)
  end

  ##
  #
  # Create a connection entry for the value table
  #
  def self.object_entry(name, connection)
    entry_for(name, connection, :object)
  end


  private

  def select(selector, value)
    raise ArgumentError, "using selector #{selector} on empty value" if value.nil?
    eval("#{value}#{selector}")
  end

end

