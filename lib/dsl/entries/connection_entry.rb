require 'dsl/entries/entry'

class ConnectionEntry < Entry

  def initialize( name, value, selector = nil, value_table)
    super(name, value, selector)
    @value_table = value_table
  end

  def to_final
    value = @value_table.internal_lookup(@value)
    Selector.run(value, selector)
  end

end