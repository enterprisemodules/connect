require 'hash_extensions'
require 'method_hash'

module Connect
  ##
  #
  # This is an empty marker class inheriting Hash. We use this maker class to detect the final full representation
  # of an object. When we present this to a selector, we can skip the name
  #
  class ObjectRepresentation < Hash
    include MethodHashMethods

    def value
      first[1]
    end
  end
end
