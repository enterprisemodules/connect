require 'hash_extensions'
require 'method_hash'

module Connect
  ##
  #
  # Has all the begaviour of an defined object. Allows for setting and overriding the data
  #
  class ObjectDefinition < Hash
    include MethodHashMethods

    ##
    #
    # Initialize a object definition for the object table and the value table
    #
    # @param type [String] the type of object
    # @param name [String] the name of the object
    # @param data [Hash] the content of the object
    #
    def initialize(type, name, data)
      identify(type, name)
      #
      # To make sure there are no lookup problems mixing
      # symbols and strins, we force all keys to strings
      #
      data.extend(HashExtensions)
      data = data.stringify_keys
      self.merge!(data)
    end

    ##
    #
    # merge the specfied data with the data already available in the object.
    # Attributes already avialble, will be overwritten.
    #
    # @param data [Hash] the data to be merged
    # @return [ObjectDefinition] the updated object
    #
    def merge!(data)
      data.extend(HashExtensions)
      data = data.stringify_keys
      super(data)
    end

    ##
    #
    # Make sure we have the final object in the connection. Because an object is already
    # an end value, we retrurn self.
    #
    # @return [ObjectDefinition]
    #
    def to_final
      self
    end

    ##
    #
    # Translate the current object to an external representation
    #
    # @return [Hash] a hash containing the name as key and a [Hash] containing the object values as value
    #
    def to_ext
      { __name__ => without_private_entries }
    end

    ##
    #
    # Translate the object values to a Hash
    #
    # @return [Hash] a [Hash] containing the object values
    #
    def to_hash
      without_private_entries
    end

    private

    #
    # Remove all private entries from the Object hash
    #
    # @return [Hash] hash containing all public data
    #
    def without_private_entries
      hash = dup
      hash.delete_if { |k, _v| k =~ /__.*__/ }
      hash
    end

    ##
    #
    # Transform the object so it is ready for selection
    #
    # @return [Hash] hash containing all public data
    def for_selection
      without_private_entries
    end

    ##
    #
    # set the identity of the object by setting the right internal values
    #
    # @param type [String] the type of object
    # @param name [String] the name of the object
    #
    def identify(type, name)
      self['__name__'] = name
      self['__type__'] = type
    end
  end
end
