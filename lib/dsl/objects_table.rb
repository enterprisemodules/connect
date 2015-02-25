require 'dsl/object_entry'

class ObjectsTable

  def initialize
    @objects_table = {}
  end

  def add(type, name, values)
    object = from_table(type, name)
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
    case type
    when 'node'       then Node.new(type, name, values)
    else  ObjectEntry.new(type, name, values)
    end
  end

  private

  def key(type,name)
    "__#{name}__#{type}__"
  end

  def add_new_object(type, name, values)
    object = ObjectsTable.entry(type, name, values)
    to_table(object)
  end

  def from_table(type, name)
    @objects_table.fetch(key(type,name)) { to_table(ObjectEntry.new(type,name, {}))}
  end

  def to_table(object)
    type = object.__type__
    name = object.__name__
    @objects_table[key(type,name)] = object
  end

  def add_values_to_existing!(object, values)
    object.merge!(values)
  end

end
