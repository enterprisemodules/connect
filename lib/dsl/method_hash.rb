#
# This class allows the elements of a Hash te be accessed
# with the . syntax. e.g: value['my_key'] is value.my_key
#
class MethodHash < Hash

  def method_missing(method_sym, *arguments, &block)
    key = method_sym.to_s
    if self.has_key?(key)
      self[method_sym.to_s]
    else
      super
    end
  end

  def [](index)
    raise "#{index} not found" unless self.has_key?(index)
    super
  end

end
