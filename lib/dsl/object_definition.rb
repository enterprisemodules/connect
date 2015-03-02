require 'hash_extensions'
require 'method_hash'

class ObjectDefinition < Hash
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

  def to_final
    self
  end

  def to_ext
    { __name__ => without_private_entries }
  end

  def to_hash
    without_private_entries  
  end

  def without_private_entries
    hash = self.dup
    hash.delete_if {|k,v| k=~/__.*__/ }
    hash
  end

  def for_selection
    without_private_entries
  end


  def identify(type,name)
    self['__name__'] = name
    self['__type__'] = type
  end 

end
