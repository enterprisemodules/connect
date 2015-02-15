require 'ostruct'

class Entry < OpenStruct

  def initialize(data)
    super(data)
  end

  def to_value
    { __name__ => without_private_entries(marshal_dump)}
  end

  def without_private_entries(hash)
    new_hash = hash.dup
    new_hash.delete_if {|k,v| k=~/__.*__/ }
    new_hash
  end

end
