#
# This is inspector used for objects and values
#
module Inspector
  def inspect(value)
    if defined?(AwesomePrint::Inspector)
      value.ai(:indent => 2)
    else
      value.inspect
    end
  end
end
