require 'dsl/object_entry'

class NullObjectEntry < ObjectEntry 

  def initialize(data = nil)
  end

  def merge(data)
    ObjectEntry.new(data)
  end

  def merge!(data)
    ObjectEntry.new(data)
  end

  def nil?
    true
  end

  def __name__
    nil
  end

  def __type__
    nil
  end


  def to_hash
    nil
  end

  def to_value
    nil
  end


end
