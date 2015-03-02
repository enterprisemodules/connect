require 'dsl/entries/entry'

class NullEntry < Entry

  def initialize()
    @value = nil
  end

  def for_selection
    nil
  end

  def to_ext
    nil
  end

end