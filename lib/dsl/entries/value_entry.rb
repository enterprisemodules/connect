require 'dsl/entries/entry'

class ValueEntry < Entry

  def to_ext
    value = case @value
    when Array 
      @value.map {|e| e.respond_to?(:to_ext) ? e.to_ext : e}
    when Hash
      MethodHash[@value.map {|k,v| v.respond_to?(:to_ext) ? [k, v.to_ext] : [k, v]}]
    else
      @value        
    end
    value
  end

  def for_selection
    @value
  end

end