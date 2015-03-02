module MethodHashMethods
  def method_missing(method_sym, *arguments, &block)
    key = method_sym.to_s
    if self.has_key?(key)
      self[key]
    else
      raise ArgumentError, "requested unassigned attribute #{key} from #{self}"
      super
    end
  end

  def [](index)
    raise "#{index} not found" unless self.has_key?(index)
    super
  end
end

class MethodHash < Hash
  include MethodHashMethods
end