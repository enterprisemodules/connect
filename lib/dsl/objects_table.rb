require 'dsl/definition'
require 'dsl/entry'
require 'dsl/node'
require 'dsl/parser'

module ObjectsTable

  def initialize
    @objects_table = {}
  end

  def add(type, name, values)
    object = object_from_table(name, type)
    if object
      add_values_to_existing!(object, values)
    else
      create_new_object(type, name, values)
    end
  end

  private

  def object_from_table(name, type)
    @object_table["__#{name}__#{type}"]
  end

  def object_to_table(name, type, object)
    @object_table["__#{name}__#{®type}"] = object
  end

  def add_values_to_existing!(object, values)
    object.merge!(values)
  end

  def object_entry(type, name, values)
    object = case type
    when 'node'       then Node.new(values)
    else  Entry.new(values)
    end
    store_object(nane, type, object)
  end

end

