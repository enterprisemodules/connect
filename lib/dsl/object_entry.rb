require 'hash_extensions'

class ObjectEntry < Hash

  def initialize(data)
    data.extend(HashExtensions)
    data = data.stringify_keys
    #
    # To make sure there are no lookup problems mixing
    # symbols and strins, we force all keys to strings
    #
    self.merge!(data)
  end

  def merge(data)
    data.extend(HashExtensions)
    data = data.stringify_keys
    super(data)
  end


  def merge!(data)
    data.extend(HashExtensions)
    data = data.stringify_keys
    super(data)
  end

  def method_missing(method_sym, *arguments, &block)
    key = method_sym.to_s
    if self.has_key?(key)
      self[key]
    else
      super
    end
  end

  def [](index)
    raise "#{index} not found" unless self.has_key?(index)
    super
  end

  def to_hash
    without_private_entries  
  end

  def without_private_entries
    hash = self.dup
    hash.delete_if {|k,v| k=~/__.*__/ }
    hash
  end

end
