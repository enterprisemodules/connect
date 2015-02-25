require 'dsl/parser'
require 'dsl/values_table'
require 'dsl/objects_table'
require 'dsl/selector'
require 'dsl/interpolator'

class Dsl < Racc::Parser

  attr_reader :interpolator

  DEFAULT_PATH = "/etc/puppet/config/"

  def initialize( values_table    = ValuesTable.new, 
                    objects_table = ObjectsTable.new, 
                    default_path  = DEFAULT_PATH,
                    interpolator  = Interpolator.new(self)
                    )
    @values_table  = values_table 
    @objects_table = objects_table 
    @default_path  = default_path
    @interpolator  = interpolator
  end
  ##
  #
  # Assign the value to the name
  #
  def assign(name, value)
    entry = value.is_a?(ObjectEntry) ?
      ValuesTable.object_entry(name, value) :
      ValuesTable.value_entry(name, value)
    add_value(entry)
  end

  ##
  #
  # Connect the variable to an other variable in the value table
  #
  def connect(from, to, selector = nil)
    entry = ValuesTable.connection_entry(from, to, selector)
    add_value(entry)
  end

  ##
  #
  # include the specfied file in the parse process.
  #
  def include_file(name)
    full_name = full_name_for_file(name)
    fail ArgumentError, "config file #{name} not found" unless full_name
    content = IO.read(full_name)
    scan_str(content)
  end

  def interpolate(string)
    @interpolator.translate(string)
  end

  ##
  #
  # Define or lookup an object. If the values is empty, this method returns just the values.
  # It the values parameter is set, a new entry will be added to the objects table
  #
  def define(type, name, values = nil, iterator = nil, selector = nil)
    raise ArgumentError, 'no iterator allowed if no block defined' if values.nil? && ! iterator.nil?
    validate_iterator( iterator) unless iterator.nil?
    add_object(type, name, values) if values
    value = lookup_object(type, name)
    Selector.run(value, selector)
  end

  ##
  #
  # For debuggging and testing only
  #
  def self.parse(content)
    @instance   = self.new
    @instance.parse(content)
  end  

  ##
  #
  # add an object with a specfied name and type and value to the objects table. 
  #
  def add_object(name, type, values)
    @objects_table.add(name, type, values)
  end

  ##
  #
  # Fetch object identified by the name and the type from the objects table
  #
  def lookup_object(type, name)
    @objects_table.lookup(type,name)
  end

  ##
  #
  # Add the specified value identified by the name to the value table
  #
  def add_value(entry)
    @values_table.add(entry)
  end

  ##
  #
  # Lookup the values specified by the name from the value table. 
  #
  def lookup_value(name)
    @values_table.lookup(name)
  end

private
  
  def validate_iterator(iterator)
    invalid_keys = iterator.keys - [:from, :to]
    raise ArgumentError, 'from value missing from iterator' if iterator[:from].nil?
    raise ArgumentError, 'to value missing from iterator' if iterator[:to].nil?
    raise ArgumentError, "iterator contains unknown key(s): #{invalid_keys}" if invalid_keys
  end

  def full_name_for_file(name)
    name = Pathname(name)
    return name.to_s if name.absolute?
    name = Pathname.new(name.to_s + '.config') unless name.extname == '.config'
    path = Pathname.new(@default_path) + name 
    path.exist? ? path : nil
  end

end

