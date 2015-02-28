require 'hash_extensions'
require 'method_hash'

class ObjectEntry < Hash
  include MethodHashMethods

  def initialize(type,name, data)
    identify(type,name)
    #
    # To make sure there are no lookup problems mixing
    # symbols and strins, we force all keys to strings
    #
    data.extend(HashExtensions)
    data = data.stringify_keys
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

  def to_value
    { __name__ => to_hash}
  end

  def to_hash
    without_private_entries  
  end

  def without_private_entries
    hash = self.dup
    hash.delete_if {|k,v| k=~/__.*__/ }
    hash
  end

  def identify(type,name)
    self['__name__'] = name
    self['__type__'] = type
  end 

end
