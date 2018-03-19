module Connect
  ##
  #
  # The host for special helper methods
  #
  class ExtendedArray < ::Array
    ##
    #
    # return an array with the specified element extracted from the hashes.
    # For this method to work, your array must be filled with objects or Hashes
    #
    # @param element [String] the element to extract
    def extract(element)
      collect { |e| e.send(element) }
    end
  end
end
