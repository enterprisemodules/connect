require 'dsl/entry'
require 'byebug'

class ObjectsTable

  def initialize
    @objects_table = {}
  end

  def add(type, name, values)
    object = from_table(name, type)
    if object
      add_values_to_existing!(object, values)
    else
      add_new_object(type, name, values)
    end
  end

  def lookup(type, name)
    from_table(type, name)
  end

  def self.entry(type, name, values)
    values.merge!({
      :__name__ => name,
      :__type__ => type
    })
    case type
    when 'node'       then Node.new(values)
    else  Entry.new(values)
    end
  end

  private

  def add_new_object(type, name, values)
    object = ObjectsTable.entry(type, name, values)
    to_table(object)
  end

  def from_table(type, name)
    @objects_table["__#{name}__#{type}"]
  end

  def to_table(object)
    @objects_table["__#{object.__name__}__#{object.__type__}"] = object
  end

  def add_values_to_existing!(object, values)
    object.merge!(values)
  end


end
