##
#
# This modules allows you to access the elements of a hash with a method like syntax
#
module MethodHashMethods
  #
  # Implements the lookup of hash entries based on the method call
  #
  def method_missing(method_sym, *_arguments, &_block)
    key = method_sym.to_s
    if self.key?(key)
      self[key]
    else
      fail ArgumentError, "requested unassigned attribute #{key} from #{self}"
    end
  end

  ##
  #
  # extracts a entry from the hash
  #
  # @param index [String] the attribute name
  # @return [Any] the content of the attribute
  #
  def [](index)
    fail "#{index} not found" unless self.key?(index)
    super
  end
end

##
#
# Implements a Hash using the method Hash functionality
#
class MethodHash < Hash
  include MethodHashMethods

  #
  # To make ruby 1.8.7 compatible with ruby 1.9 and higer
  #
  def to_s
    inspect
  end
end
