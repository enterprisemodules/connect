require 'dsl/entries/entry'

class ObjectEntry < Entry

  def for_selection
    @value.to_hash
  end

  def to_ext
    { @value.__name__ => @value.to_hash}
  end

end