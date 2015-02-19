require 'dsl/definition'
require 'dsl/entry'
require 'dsl/node'
require 'dsl/parser'
require 'ruby-debug'

class Dsl < Racc::Parser

  def self.parse(content)
    @instance   = self.new
    puts @instance.tokenize(content)
    @instance.parse(content)
  end  

  def initialize
    @definitions_table = {}
    @lookup_table      = {}
  end

  def parse_file(file)
    content
  end

  def inspect
    @lookup_table.each_pair do | name, entry|
      case entry[:type]
      when :value
        puts "#{name}: #{value_for(name)}"
      when :connection
        puts "#{name}: #{value_for(name)}, value referenced through #{entry[:value]}"
      end
    end
  end

  def value_for(name)
    name = name.to_s
    scope, selector = name.split(/(\[\d+\]|\.\D.*)/)
    # TODO: Check if name is a valid name
    entry = @lookup_table.fetch(scope) { {}}
    value = case entry[:type]
    when :value
      entry[:value]
    when :connection
      value_for(entry[:value])
    else
      nil
    end
    selector ? select(selector,value) : value
  end

  def select(selector, value)
    raise ArgumentError, "using selector #{selector} on empty value" if value.nil?
    eval("#{value}#{selector}")
  end

  def set(name, value)
    entry = value_entry(name, value)
    # TODO: Warning if value exists
    @lookup_table.merge!(entry)
  end

  def connect(from, to)
    entry = connection_entry(from, to)
    # TODO: Warning if value exists
    @lookup_table.merge!(entry)
  end

  def self.to_external(data)
    case data
    when Array
      data.collect {|e| to_external(e)}
    when Hash
      data.collect {|k,v| { k => to_external(v)}}
    when Entry
      data.to_value
    else
      data
    end
  end

  def definition_for(type, name)
    definition = @definitions_table["__#{name}__#{type}"]
    if definition
      case type
      when 'node'       then Node.new(definition)
      else  Entry.new(definition)
      end
    else
      empty_definitions
    end
  end

  def empty_definitions
    OpenStruct.new
  end

  def lookup_entry(name, value, type = :value)
    name = name.to_s
    entry = { name => { :value => value, :type  => type }}
    def entry.==(value)
      first[1][:value] = Dsl.to_external(value)
    end
    entry
  end
  alias_method :value_entry, :lookup_entry

  def connection_entry(name, connection)
    lookup_entry(name, connection, :connection)
  end

  def parse(input)
    scan_str(input)
  end

  def parse_file(name)
    full_name = full_name_for_file(name)
    fail ArgumentError, "config file #{name} not found" unless full_name
    content = IO.read(full_name)
    scan_str(content)
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

