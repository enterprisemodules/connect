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
begin
  require 'byebug'
  require 'pry'
  require 'ruby-debug'
rescue LoadError
# Ignore error's in loading these files
end

module Connect
  ##
  #
  # This is a placeholder for configuration
  #
  class Config < OpenStruct
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
 
    def_delegator :@interpolator,  :translate, :interpolate

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
    def assign(name, value, xdef = nil)
      name = scoped_name_for(name)
      entry = ValuesTable.value_entry(name, value, nil, xdef)
      add_value(entry)
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
        @includer.include(names) do |content, file_name|
          push_current_parse_state
          @current_file = file_name
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
    # Define an object. If the values is empty, this method returns just the values.
    # It the values parameter is set, a new entry will be added to the objects table
    #
    def define_object(type, name, values = nil, iterator = nil, xdef = nil)
      fail ArgumentError, 'no iterator allowed if no block defined' if values.nil? && !iterator.nil?
      validate_iterator(iterator) unless iterator.nil?
      add_object(type, name, values, xdef) if values
      Entry::ObjectReference.new(type, name, nil, xdef)
    end

    ##
    #
    # Create an object reference.
    #
    def reference_object(type, name, xref = nil)
      object_reference(type,name, xref)
      Entry::ObjectReference.new(type, name, nil, xref)
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

    def xref
      Xref.new(current_file, lineno)
    end

    def xdef
      Xdef.new(current_file, lineno)
    end

    private

    def in_scope(scope)
      push_scope(scope)
      yield
      pop_scope
    end

    def push_current_parse_state
      state = {
        :ss            => @ss,
        :lineno        => @lineno,
        :current_file  => @current_file,
        :state         => @state
      }
      @include_stack << state
    end

    def pop_current_parse_state
      fail 'include stack poped beyond end' if @include_stack.empty?
      state = @include_stack.pop
      @ss           = state[:ss]
      @lineno       = state[:lineno]
      @current_file = state[:current_file]
      @state        = state[:state]
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
      (string =~ /\A(\s|\n)*\Z/) == 0
    end
  end
  # rubocop:enable ClassLength
end
