require 'dsl/parser'
require 'dsl/values_table'
require 'dsl/objects_table'

class Dsl < Racc::Parser

  def initialize
    @objects_table = ObjectsTable.new
    @values_table  = ValuesTable.new
  end

  ##
  #
  # Assign the value to the name
  #
  def assign(name, value)
    entry = ValueTable.value_entry(name, value)
    add_value(entry)
  end

  ##
  #
  # Connect the variable to an other variable in the value table
  #
  def connect(from, to)
    entry = ValueTable.connection_entry(from, to)
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


  ##
  #
  # include the specfied directory in the parse process. This means all files with the 
  # extension .config, will be added to the parse process. Files with other types will
  # be skipped
  #
  def include_directory(name)
    raise Error, 'parse directory not implemented yet'
  end

  ##
  #
  # Define or lookup an object. If the values is empty, this method returns just the values.
  # It the values parameter is set, a new entry will be added to the objects table
  #
  def define(type, name, iterator, values)
    raise Error, 'no iterator allowed if no block defined' if values.nil? && ! iterator.nil?
    if values
      entry = ObjectsTable.entry(type,name, values)
      add_object(entry)
    else
      lookup_object(name, type)
    end
  end

  ##
  #
  # For debuggging and testing only
  #
  def self.parse(content)
    @instance   = self.new
    puts @instance.tokenize(content)
    @instance.parse(content)
  end  

  ##
  #
  # add an object with a specfied name and type and value to the objects table. 
  #
  def add_object(name, type, values)
    @objects_table.add(name,type, values)
  end

  ##
  #
  # Fetch object identified by the name and the type from the objects table
  #
  def lookup_object(name, type)
    @objects_table.lookup(name,type)
  end

  ##
  #
  # Add the specified value identified by the name to the value table
  #
  def add_value(name, value)
    @values_table.add(name, value)
  end

  ##
  #
  # Lookup the values specified by the name from the value table. 
  #
  def lookup_value(name)
    @values_table.lookup(name)
  end

private
  
  def full_name_for_file(name)
    name = Pathname(name)
    return name.to_s if name.absolute?
    name = Pathname.new(name.to_s + '.config') unless name.extname == '.config'
    name = name.to_s
    path = DEFAULT_PATH.find { |dir|File.exist?(File.join(dir, name)) }
    path && File.join(path, name)
  end

end

