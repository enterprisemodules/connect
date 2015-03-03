require 'dsl/parser'
require 'dsl/values_table'
require 'dsl/objects_table'
require 'dsl/selector'
require 'dsl/interpolator'
require 'dsl/includer'
require 'dsl/entries/value_entry'
require 'dsl/entries/connection_entry'
require 'dsl/entries/object_entry'

class Dsl < Racc::Parser

  attr_reader :interpolator, :current_file

  #
  # Coveneance function to create a dsl object for a specfic include directory
  #
  def self.instance(include_dir)
    includer = Includer.new(include_dir)
    self.new(nil,nil,nil, includer)
  end

  def initialize( values_table    = nil, 
                    objects_table = nil, 
                    interpolator  = nil,
                    includer      = nil
                    )
    @values_table  = values_table || ValuesTable.new
    @objects_table = objects_table || ObjectsTable.new
    @interpolator  = interpolator || Interpolator.new(self)
    @includer      = includer || Includer.new
    @include_stack = []
    @current_scope = []
  end
  ##
  #
  # Assign the value to the name
  #
  def assign(name, value, selector = nil)
    name = scoped_name_for(name)
    entry = value.is_a?(ObjectDefinition) ?
      ValuesTable.object_entry(name, value, selector) :
      ValuesTable.value_entry(name, value, selector)
    add_value(entry)
  end

  ##
  #
  # Connect the variable to an other variable in the value table
  #
  def connect(from, to, selector = nil)
    from = scoped_name_for(from)
    to   = scoped_name_for(to)
    entry = ValuesTable.connection_entry(from, to, selector, @values_table)
    add_value(entry)
  end


  ##
  #
  # Connect the variable to an other variable in the value table
  #
  def reference(to)
    ConnectionEntry.new('', to, nil, @values_table)
  end


  ##
  #
  # include the specfied file in the parse process.
  #
  def include_file(names, scope = nil)
    push_scope(scope)
    @includer.include(names) do |  content, file_name|
      @current_file = file_name
      push_current_parse_state
      scan_str(content) unless empty_definition?(content)
      pop_current_parse_state
    end
    pop_scope
  end

  def interpolate(string)
    @interpolator.translate(string)
  end

  ##
  #
  # Define or lookup an object. If the values is empty, this method returns just the values.
  # It the values parameter is set, a new entry will be added to the objects table
  #
  def define(type, name, values = nil, iterator = nil)
    raise ArgumentError, 'no iterator allowed if no block defined' if values.nil? && ! iterator.nil?
    validate_iterator( iterator) unless iterator.nil?
    add_object(type, name, values) if values
    lookup_object(type, name)
  end

  ##
  #
  # For debuggging and testing only
  #
  def self.parse(content)
    @instance   = self.new
    @instance.parse(content) unless empty_definition?(content)
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


  def push_scope(scope)
    @current_scope << scope unless scope.nil?
  end

  def pop_scope
    @current_scope.pop
  end

private

  def push_current_parse_state
    state = {
      :ss       => @ss,
      :lineno   => @lineno,
      :state    => @state
    }
    @include_stack << state
  end

  def pop_current_parse_state
    raise Error, "include stack poped beyond end" if @include_stack.empty?
    state = @include_stack.pop
    @ss     = state[:ss]
    @lineno = state[:lineno]
    @state  = state[:state]
  end

  #
  # Returns a full scoped name if the name is not scoped. Scoped names will be returned
  # as is.
  #
  def scoped_name_for(name)
    scoped_name?(name) ? name : @current_scope.join + name
  end

  def scoped_name?(name)
    name.scan(/\:\:/).length > 0
  end
  
  def validate_iterator(iterator)
    invalid_keys = iterator.keys - [:from, :to]
    raise ArgumentError, 'from value missing from iterator' if iterator[:from].nil?
    raise ArgumentError, 'to value missing from iterator' if iterator[:to].nil?
    raise ArgumentError, "iterator contains unknown key(s): #{invalid_keys}" if invalid_keys
  end

  def empty_definition?(string)
    (string =~ /^(\s|\n)*$/) == 0 
  end

end

