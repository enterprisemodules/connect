require 'ostruct'
require 'connect/values_table'
require 'connect/objects_table'
require 'connect/selector'
require 'connect/interpolator'
require 'connect/includer'
require 'connect/entries/value'
require 'connect/entries/reference'
require 'connect/entries/interpolator'
require 'connect/datasources/base'
require 'string_extension'
require 'connect/parser'


# Ignore error's in loading these files
[ 'byebug',
  'pry',
  'ruby-debug',
].each {|f| begin; require f; rescue LoadError; end}

module Connect
  ##
  #
  # This is a placeholder for configuration
  #
  class Config < OpenStruct
  end

  class << self
    attr_accessor :logger
  end

  def self.debug(message)
    @logger.debug "CONNECT: #{message}" if @logger && @logger.respond_to?(:debug)
  end

  def self.warn(message)
    @logger.warn "CONNECT: #{message}" if @logger && @logger.respond_to?(:warn)
  end

  ##
  #
  # Two structures to hold an reference to a definition and usage
  #
  Xref = Struct.new(:file_name, :lineno)
  Xdef = Struct.new(:file_name, :lineno)
  ##
  #
  # This class contains all methods called by the DSL parser
  #
  # rubocop:disable ClassLength
  class Dsl < Racc::Parser
    extend Forwardable

    #
    # This instance variables are saved when pushing and popping parser state
    # The parser is popped and pushed on includes
    #
    STATE_VARIABLES = [
      :ss,
      :lineno,
      :current_file,
      :racc_state,
      :racc_t,
      :racc_val,
      :racc_read_next,
    ]

    attr_reader :interpolator, :current_file, :config

    #
    # A lot of the object work is delegated to the objects_table
    #
    def_delegator :@objects_table,  :add,                  :add_object
    def_delegator :@objects_table,  :lookup,               :lookup_object
    def_delegator :@objects_table,  :dump,                 :dump_objects
    def_delegator :@objects_table,  :definitions,          :object_definitions
    def_delegator :@objects_table,  :references,           :object_references
    def_delegator :@objects_table,  :register_reference,   :object_reference
    #
    # A lot of the values work is delegated to the values_table
    #
    def_delegator :@values_table,  :add,                  :add_value
    def_delegator :@values_table,  :lookup,               :lookup_value
    def_delegator :@values_table,  :dump,                 :dump_values
    def_delegator :@values_table,  :definitions,          :value_definitions
    def_delegator :@values_table,  :references,           :value_references
    def_delegator :@values_table,  :register_reference,   :value_reference

    def_delegator :@interpolator,  :contains_interpolation?, :contains_interpolation?

    class << self
      def config
        @config ||= Config.new
      end
    end
    #
    # Coveneance function to create a dsl object for a specfic include directory
    #
    def self.instance(include_dir)
      includer = Includer.new(include_dir)
      new(nil, nil, nil, includer)
    end

    def initialize(values_table    = nil,
                      objects_table = nil,
                      interpolator  = nil,
                      includer      = nil
                      )
      # @yydebug = true
      @values_table  = values_table || ValuesTable.new
      @objects_table = objects_table || ObjectsTable.new
      Connect::Entry::Base.values_table  = @values_table
      Connect::Entry::Base.objects_table = @objects_table
      @interpolator  = interpolator || Interpolator.new(@values_table)
      @includer      = includer || Includer.new
      @include_stack = []
      @current_scope = []
    end
    ##
    #
    # Assign the value to the name
    #
    # @param name [String] the name of the assignment
    # @param value [Any] the value of the assignment
    #
    def assign(name, value, xdef = nil)
      interpolator_not_allowed(name, 'lvar in assignment')
      process_multiline_value(value)
      if value.is_a?(Connect::Entry::Base)
        Connect.debug "Assign #{value.inspect} to #{name}."
      else
        Connect.debug "Assign #{value} to #{name}."
      end
      name = scoped_name_for(name)
      entry = ValuesTable.value_entry(name, value, nil, xdef)
      add_value(entry)
    end

    def double_quoted(value, xref = nil)
      if contains_interpolation?(value)
        interpolate(value, xref)
      else
        value
      end
    end

    def lookup_objects(type, keys)
      @objects_table.entries(type, keys).reduce([]) do | c, v |
        type = v[0]
        name = v[1]
        c << [type, lookup_object(type, name).full_representation]
      end
    end

    def lookup_values(keys)
      @values_table.entries(keys).reduce([]) {| c, v| c << [v,lookup_value(v)]}
    end

    ##
    #
    # Add the selector to the last object
    #
    def selector(value, selector)
      value.selector = selector
      value
    end

    ##
    #
    # Connect the variable to an other variable in the value table
    #
    def interpolate(value, xref = nil)
      Entry::Interpolator.new(value, nil, xref)
    end

    ##
    #
    # Connect the variable to an other variable in the value table
    #
    def reference(parameter, xref = nil)
      value_reference(parameter, xref)
      Entry::Reference.new(parameter, nil, xref)
    end
    ##
    #
    # include the specfied file in the parse process.
    #
    def include_file(names, scope = nil)
      in_scope(scope) do
        names = interpolated_value(names)
        @includer.include(names) do |content, file_name|
          push_current_parse_state
          @current_file = file_name
          Connect.debug "parsing Connect config file #{file_name}."
          scan_str(content) unless empty_definition?(content)
          pop_current_parse_state
        end
      end
    end

    ##
    #
    # create a datasource with the specfied name. A datasource object will be created
    # who's type is Connect::Datasources::name. The Puppet autoloader will
    # try to locate this object in any of the loaded gems and modules.
    #
    # When it is found, it is initialized whit the name and the passed parameters
    #
    # @param name [String] the name of the datasource
    # @param parameters [Array] an arry of parameters to pass to the datasource
    #
    def datasource(name, *parameters)
      name = interpolated_value(name)
      Connect.debug "Loading datasource #{name}"
      source_name = name.to_s.split('_').collect(&:capitalize).join # Camelize
      klass_name = "Connect::Datasources::#{source_name}"
      klass = Puppet::Pops::Types::ClassLoader.provide_from_string(klass_name)
      if klass
        @current_importer = klass.new(name, *parameters)
      else
        fail ArgumentError, "specfied importer '#{name}' doesn't exist"
      end
    end

    ##
    #
    # Import the specified data into the values list
    #
    def import(variable_name, lookup)
      name = interpolated_value(name)
      Connect.debug "Importing variable #{variable_name}."
      fail 'no current importer' unless @current_importer
      value = @current_importer.lookup(lookup)
      assign(variable_name, value)
    end

    ##
    #
    # Define an object. If the values is empty, this method returns just the values.
    # It the values parameter is set, a new entry will be added to the objects table
    #
    def define_object(type, name, values = nil, iterators = nil, xdef = nil)
      name = interpolated_value(name)
      Connect.debug("Defining object #{name} as type #{type}.")
      fail ArgumentError, 'Iterators only allowed with block definition' if values.nil? && !iterators.nil?
      validate_iterators(iterators) unless iterators.nil?
      if iterators
        add_objects_with_iterators(type, name, values, xdef, iterators)
      else
        add_object(type, name, values, xdef) if values
      end
      Entry::ObjectReference.new(type, name, nil, xdef)
    end

    def add_objects_with_iterators(type, name, values, xdef, iterators)
      name = interpolated_value(name)
      iterator_values = {}
      iterators.each_pair {|k,v| iterator_values[k] = values_from_iterator(v,k)}
      max_size  = iterator_values.collect{|k,v| v.size}.max
      iterator_values.each_pair {|k,v| iterator_values[k] = v * ((max_size/v.size) + (max_size % v.size))}
      (0..max_size).each do | index|
        value_hash = iterator_values.keys.reduce({}) {|v,k| v.merge!({k.to_sym => iterator_values[k][index]})}
        object_name   = name % value_hash
        object_values = substitute_values(values, value_hash)
        add_object(type, object_name, object_values, xdef)
      end
    end

    ##
    #
    # Create an object reference.
    #
    def reference_object(type, name, xref = nil)
      name = interpolated_value(name)
      object_reference(type, name, xref)
      Entry::ObjectReference.new(type, name, nil, xref)
    end

    ##
    #
    # Create an regexp object reference.
    #
    def reference_objects(type, regexp_str, xref = nil)
      regexp = Regexp.new(regexp_str)
      object_reference(type, regexp, xref)
      Entry::RegexpObjectReference.new(type, regexp, nil, xref)
    end

    ##
    #
    # Push the current variable scope to the stack.
    #
    # @param scope [String] the new scope scope
    def push_scope(scope)
      @current_scope << scope unless scope.nil?
    end

    ##
    #
    # Pop's the last scope from the stack
    #
    def pop_scope
      @current_scope.pop
    end

    ##
    #
    # Translate strings in a set of parameters to quoted strings
    #
    # @param parameters [Array] the set of parameters to recieve from the parser
    #
    def to_param(parameters)
      parameters = [parameters] unless parameters.is_a?(Array)
      parameters.collect { |p| p.is_a?(String) ? "'#{p}'" : p }.join(',')
    end

    def xref
      Xref.new(current_file, lineno)
    end

    def xdef
      Xdef.new(current_file, lineno)
    end

    private

    def interpolator_not_allowed(name, type)
      fail "#{name.value} is not allowed as a #{type}" if name.is_a?(Connect::Entry::Base)
    end

    def interpolated_value(name)
      name.is_a?(Connect::Entry::Base) ? name.to_ext : name
    end


    def substitute_values(hash, values_hash)
      hash.extend(HashExtensions)
      hash.transform_hash do |hash, key, content|
        hash[key] = content % values_hash
      end
    end

    def values_from_iterator(iterator, name)
      range = Range.new( as_value(iterator[:from]),  as_value(iterator[:to])).step(as_value(iterator[:step])).to_a
    rescue ArgumentError
      raise "Invalid arguments for Object iterator, around line #{lineno} of config file '#{current_file}'"
    ensure
      elements = range.count
      if elements > 500
        raise "Iterator #{name} is #{elements} elements long, but maximum size is 500, around line #{lineno} of config file '#{current_file}'"
      end
      range
    end

    def as_value(iterator_value)
      iterator_value.class == Connect::Entry::Reference ? iterator_value.final : iterator_value
    end

    def in_scope(scope)
      push_scope(scope)
      yield
      pop_scope
    end

    def push_current_parse_state
      state = pusher(STATE_VARIABLES)
      @include_stack << state
    end

    def pop_current_parse_state
      fail 'include stack poped beyond end' if @include_stack.empty?
      state = @include_stack.pop
      popper(state, STATE_VARIABLES)
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

    def validate_iterators(iterators)
      iterators.each_value {| iterator| validate_iterator(iterator)}
    end

    def validate_iterator(iterator)
      invalid_keys = iterator.keys - [:from, :to, :step]
      fail ArgumentError, "from value missing from iterator, around line #{lineno} of config file '#{current_file}'"  if iterator[:from].nil?
      fail ArgumentError, "to value missing from iterator, around line #{lineno} of config file '#{current_file}'" if iterator[:to].nil?
      fail ArgumentError, "to value missing from iterator, error around line #{lineno} of config file '#{current_file}'" if iterator[:step].nil?
      fail ArgumentError, "iterator contains unknown key(s): #{invalid_keys}, error around line #{lineno} of config file '#{current_file}'" unless invalid_keys.empty?
    end

    def empty_definition?(string)
      (string =~ /\A(\s|\n|#.*)*\Z/) == 0
    end

    def pusher( entries)
      state = {}
      entries.each do |entry|
        state[entry] = instance_variable_get("@#{entry}".to_sym)
      end
      state
    end

    def process_multiline_value(value)
      @lineno ||= 0
      @lineno+= value.lines.count if value.is_a?(String)
    end


    def popper (state, entries)
      entries.each do |entry|
        instance_variable_set("@#{entry}".to_sym, state[entry])
      end
    end

  end
  # rubocop:enable ClassLength
end
