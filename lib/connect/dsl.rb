require 'ostruct'
require 'connect/parser'
require 'connect/values_table'
require 'connect/objects_table'
require 'connect/selector'
require 'connect/interpolator'
require 'connect/includer'
require 'connect/entries/value'
require 'connect/entries/reference'
require 'connect/datasources/base'

module Connect
  ##
  #
  # This is a placeholder for configuration
  #
  class Config < OpenStruct
  end
  ##
  #
  # This class contains all methods called by the DSL parser
  #
  # rubocop:disable ClassLength
  class Dsl < Racc::Parser
    attr_reader :interpolator, :current_file, :config
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
      @interpolator  = interpolator || Interpolator.new(self)
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
    def assign(name, value)
      name = scoped_name_for(name)
      entry = ValuesTable.value_entry(name, value)
      add_value(entry)
    end

    def lookup_objects(keys, type)
      # TODO: Implement this
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
    def reference(to)
      Entry::Reference.new(to, nil)
    end
    ##
    #
    # include the specfied file in the parse process.
    #
    def include_file(names, scope = nil)
      in_scope(scope) do
        @includer.include(names) do |content, file_name|
          @current_file = file_name
          push_current_parse_state
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
      source_name = name.to_s.capitalize
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
      fail 'no current importer' unless @current_importer
      value = @current_importer.lookup(lookup)
      assign(variable_name, value)
    end

    ##
    #
    # Interpolate the specfied strings and transalte any interoplation strings to the actual values
    #
    # @param string [String] the string to interpolate
    def interpolate(string)
      @interpolator.translate(string)
    end

    ##
    #
    # Define or lookup an object. If the values is empty, this method returns just the values.
    # It the values parameter is set, a new entry will be added to the objects table
    #
    def define_object(type, name, values = nil, iterator = nil)
      fail ArgumentError, 'no iterator allowed if no block defined' if values.nil? && !iterator.nil?
      validate_iterator(iterator) unless iterator.nil?
      add_object(type, name, values) if values
      Entry::ObjectReference.new(type, name, nil)
    end

    ##
    #
    # Define or lookup an object. If the values is empty, this method returns just the values.
    # It the values parameter is set, a new entry will be added to the objects table
    #
    def reference_object(type, name)
      Entry::ObjectReference.new(type, name, nil)
    end

    ##
    #
    # add an object with a specfied name and type and value to the objects table.
    #
    # @param name [String] the name of the object
    # @param type [String] the type of object
    # @param values [Hash] a [Hash] of object values
    #
    def add_object(name, type, values)
      @objects_table.add(name, type, values)
    end

    ##
    #
    # Fetch object identified by the name and the type from the objects table
    #
    # @param type [String] the type of object
    # @param name [String] the name of the object
    #
    # @return [ObjectDefinition] the object
    #
    def lookup_object(type, name)
      @objects_table.lookup(type, name)
    end

    ##
    #
    # Add the specified value identified by the name to the value table
    #
    # @param entry [Connect::Entries::Base] the antry to add the the values table
    #
    def add_value(entry)
      @values_table.add(entry)
    end

    ##
    #
    # Lookup the values specified by the name from the value table.
    #
    # @param name [String] the name/ket to lookup in the value_table
    #
    def lookup_value(name)
      @values_table.lookup(name)
    end

    ##
    #
    # Dump the objects table
    #
    # @return [String] the content of the objects table
    def dump_objects
      @objects_table.dump
    end

    ##
    #
    # Dump the values table
    #
    # @return [String] the content of the values table
    #
    def dump_values
      @values_table.dump
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
      parameters.collect { |p| p.is_a?(String) ? "'#{p}'" : p }.join(',')
    end

    private

    def in_scope(scope)
      push_scope(scope)
      yield
      pop_scope
    end

    def push_current_parse_state
      state = {
        :ss       => @ss,
        :lineno   => @lineno,
        :state    => @state
      }
      @include_stack << state
    end

    def pop_current_parse_state
      fail 'include stack poped beyond end' if @include_stack.empty?
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
      fail ArgumentError, 'from value missing from iterator' if iterator[:from].nil?
      fail ArgumentError, 'to value missing from iterator' if iterator[:to].nil?
      fail ArgumentError, "iterator contains unknown key(s): #{invalid_keys}" if invalid_keys
    end

    def empty_definition?(string)
      (string =~ /^(\s|\n)*$/) == 0
    end
  end
  # rubocop:enable ClassLength
end
