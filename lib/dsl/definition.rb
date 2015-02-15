require 'ostruct'

class Definition


  def initialize(name, type, value = nil, no = nil)
    @name   = name
    @type   = type
    @no     = no
    @values = OpenStruct.new(:__name__ => @name, :__type__ => @type)
  end

  def type?(type)
    @type == type 
  end

  def to_hash
    {"__#{@name}__#{@type}" => @values}
  end

  def to_value
    without_private_entries(@values.to_hash).marshal_dump
  end

  def method_missing(method_sym, *arguments, &block)
    arguments = arguments.flatten.first
    case arguments
    when String
      @values[method_sym] = arguments % @no
    else
      @values[method_sym] = arguments
    end
  end

  def without_private_entries(hash)
    hash.delete_if {|k,v| k=~/__.*__/ }
    hash
  end

end
