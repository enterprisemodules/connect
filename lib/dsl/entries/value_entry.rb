require 'dsl/entries/entry'

class ValueEntry < Entry

  def to_ext
    value = case @value
    when Array 
      @value.map {|e| e.respond_to?(:to_ext) ? e.to_ext : e}
    when Hash
      MethodHash[@value.map {|k,v| convert_hash_entry(k,v) }]
    else
      @value        
    end
    value
  end

  def for_selection
    @value
  end

  private

  def convert_hash_entry(k,v)
    if v.is_a?(ObjectDefinition) # Special case
      key, value = v.to_ext.to_a[0]
      [key,value]
    else
      v.respond_to?(:to_ext) ? [k, v.to_ext] : [k, v]
    end
  end

end