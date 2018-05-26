##
#
# This modules allows you to access the elements of a hash with a method like syntax
#
module MethodHashMethods
  #
  # Implements the lookup of hash entries based on the method call
  #
  # rubocop:disable Style/MethodMissingSuper
  # rubocop:disable Style/MissingRespondToMissing
  def method_missing(method_sym, *_arguments, &_block)
    key = method_sym.to_s
    return self[key] if key?(key)
    raise ArgumentError, "requested unassigned attribute #{key} from #{self}"
  end
  # rubocop:enable Style/MethodMissingSuper
  # rubocop:enable Style/MissingRespondToMissing

  ##
  #
  # extracts a entry from the hash
  #
  # @param index [String] the attribute name
  # @return [Any] the content of the attribute
  #
  def [](index)
    raise "#{index} not found" unless key?(index)
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
  # To make ruby 1.8.7 compatible with ruby 1.9 and higher
  #
  def to_s
    inspect
  end

  #
  # To make ruby 1.8.7 compatible with ruby 1.9 and higher
  #
  def to_str
    inspect
  end

  def to_ary
    nil
  end
end
